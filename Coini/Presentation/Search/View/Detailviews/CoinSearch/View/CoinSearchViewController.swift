//
//  CoinSearchViewController.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CoinSearchViewController: BaseViewController<CoinSearchView> {
    
    let viewModel = CoinSearchViewModel()
    let disposeBag = DisposeBag()
    
    override func bind() {
        
        let input = CoinSearchViewModel.Input(coinSelected: mainView.coinTableView.rx.itemSelected)
        let output = viewModel.transform(input: input)
        
        // 검색 결과
        output.searchResults
            .bind(to: mainView.coinTableView.rx.items(cellIdentifier: CoinSearchTableViewCell.identifier, cellType: CoinSearchTableViewCell.self)) { (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
    }
    
}
