//
//  CoinInfoViewController.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CoinInfoViewController: BaseViewController<CoinInfoView> {
    
    let viewModel = CoinInfoViewModel()
    let disposeBag = DisposeBag()
    
    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "가상자산 / 심볼 검색"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .customNavy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    override func bind() {
        let input = CoinInfoViewModel.Input(viewDidLoadTrigger: Observable.just(0))
        let output = viewModel.transform(input: input)

        // 인기 검색어
        output.coinItems
            .bind(to: mainView.keywordCollectionView.rx.items(cellIdentifier: KeywordCollectionViewCell.identifier, cellType: KeywordCollectionViewCell.self)) { (row, element, cell) in
                cell.configureData(row: row, data: element)
            }
            .disposed(by: disposeBag)
        
        // 인기 NFT
        output.NFTItems
            .bind(to: mainView.nftCollectionView.rx.items(cellIdentifier: NFTCollectionViewCell.identifier, cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        // 조회 시간
        output.networkTime
            .map { DateFormatter.networkTime($0) }
            .bind(to: mainView.keywordDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 검색
        
        mainView.searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .map { _ in self.mainView.searchBar.resignFirstResponder() }
            .withLatestFrom(mainView.searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                print(value)
                if !value.trimmingCharacters(in: .whitespaces).isEmpty {
                    // 화면 전환
                    let vc = SearchViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
