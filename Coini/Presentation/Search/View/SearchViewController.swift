//
//  SearchViewController.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController<SearchView> {
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.deviceWidth = view.frame.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateData.accept(())
    }

    override func configureNavigation() {
        navigationItem.leftBarButtonItems = [
            mainView.backButton,
            UIBarButtonItem(customView: mainView.searchTextField)
        ]
    }
    
    override func bind() {
        
        var scrolledByUser = false
        
        let input = SearchViewModel.Input(
            bacButtonTapped: mainView.backButton.rx.tap,
            searchButtonTapped: mainView.searchTextField.rx.controlEvent(.editingDidEndOnExit)
                .withLatestFrom(mainView.searchTextField.rx.text.orEmpty)
                .distinctUntilChanged(),
            tabSelected: mainView.headerTabCollectionView.rx.itemSelected,
            swipe: mainView.pageCollectionView.rx.didScroll
                .filter { scrolledByUser }
                .withLatestFrom(mainView.pageCollectionView.rx.contentOffset.changed)
                .map { $0.x }
                .distinctUntilChanged()
        )
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼
        output.bacButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 검색어
        output.searchKeyword
            .bind(to: mainView.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 헤더탭
        output.headerItems
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.headerTabCollectionView.rx.items(cellIdentifier: HeaderTabCollectionViewCell.identifier, cellType: HeaderTabCollectionViewCell.self)) { (row, element, cell) in
                print("🔥🔥🔥🔥🔥")
                print(element)
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        // 페이지뷰
        output.detailViews
            .bind(to: mainView.pageCollectionView.rx.items(cellIdentifier: PageCollectionViewCell.identifier, cellType: PageCollectionViewCell.self)) { (row, element, cell) in
                print("🔍🔍🔍🔍🔍🔍")
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        // 코인디테일화면의 테이블뷰 선택 -> 화면 전환
        output.showDetailCoin
            .bind(with: self) { owner, value in
                let vc = SearchDetailViewController()
                vc.viewModel.detailCoinId.accept(value)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 헤더 탭했을 때 자동 scroll 적용
        output.scrollToIndex
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, index in
                let point = CGPoint(x: Int(owner.viewModel.deviceWidth) * index, y: 0)
                owner.mainView.pageCollectionView.setContentOffset(point, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 사용자가 스와이프한 경우
        mainView.pageCollectionView.rx.willBeginDragging
            .bind(with: self) { owner, _ in
                scrolledByUser = true
            }
            .disposed(by: disposeBag)
        
        // 사용자가 스와이프한 경우 + 자동 스크롤일 경우
        mainView.pageCollectionView.rx.didEndDecelerating
            .bind(with: self) { owner, _ in
                scrolledByUser = false
            }
            .disposed(by: disposeBag)
    }
    
}
