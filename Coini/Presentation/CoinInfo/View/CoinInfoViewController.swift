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

        output.coinItems
            .bind(to: mainView.keywordCollectionView.rx.items(cellIdentifier: KeywordCollectionViewCell.identifier, cellType: KeywordCollectionViewCell.self)) { (row, element, cell) in
                cell.configureData(row: row, data: element)
            }
            .disposed(by: disposeBag)
        
        output.NFTItems
            .bind(to: mainView.nftCollectionView.rx.items(cellIdentifier: NFTCollectionViewCell.identifier, cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.networkTime
            .map { DateFormatter.networkTime($0) }
            .bind(to: mainView.keywordDateLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    
}
