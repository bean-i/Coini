//
//  SearchDetailViewController.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class SearchDetailViewController: BaseViewController<SearchDetailView> {
    
    let viewModel = SearchDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func configureNavigation() {
        navigationItem.titleView = mainView.navStackView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.navButton)
    }
    
    override func bind() {
        let input = SearchDetailViewModel.Input(
            stockMoreButtonTapped: mainView.stockInfoHeader.moreButton.rx.tap,
            investMoreButtonTapped: mainView.investInfoHeader.moreButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        mainView.navButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.mainView.navButton.updateStatus()
                if owner.mainView.navButton.isSelected {
                    owner.view.makeToast("\(owner.mainView.navTitleLabel.text ?? "")이(가) 즐겨찾기 되었습니다.")
                } else {
                    owner.view.makeToast("\(owner.mainView.navTitleLabel.text ?? "")이(가) 즐겨찾기에서 제거되었습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        // 메인뷰 데이터 나타내기
        output.coinDetailInfo
            .bind(with: self) { owner, value in
                owner.mainView.configureData(data: value)
                owner.mainView.configureNavigation(title: value.name, image: value.image, coinID: value.id)
                owner.mainView.configureChart(data: value.sparkline.price)
            }
            .disposed(by: disposeBag)
        
        // 종목정보 더보기 버튼 탭
        output.stockMoreButtonTapped
            .bind(with: self) { owner, _ in
                owner.view.makeToast("🔒준비 중입니다")
            }
            .disposed(by: disposeBag)
        
        // 투자지표 더보기 버튼 탭
        output.investMoreButtonTapped
            .bind(with: self) { owner, _ in
                owner.view.makeToast("🔒준비 중입니다")
            }
            .disposed(by: disposeBag)
    }
    
}
