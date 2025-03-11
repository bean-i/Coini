//
//  CoinSearchViewController.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class CoinSearchViewController: BaseViewController<CoinSearchView> {
    
    let viewModel = CoinSearchViewModel()
    let disposeBag = DisposeBag()
    
    override func bind() {
        
        let input = CoinSearchViewModel.Input(coinSelected: mainView.coinTableView.rx.itemSelected)
        let output = viewModel.transform(input: input)

        // 검색 결과
        Observable.merge(
            output.searchResults.asObservable(),
            output.updateData.asObservable()
        )
        .bind(to: mainView.coinTableView.rx.items(cellIdentifier: CoinSearchTableViewCell.identifier, cellType: CoinSearchTableViewCell.self)) { (row, element, cell) in
            cell.configureData(data: element)
            
            cell.starButton.rx.tap
                .bind(with: self) { owner, _ in
                    cell.starButton.updateStatus()
                    if cell.starButton.isSelected {
                        owner.view.makeToast("\(element.name)이(가) 즐겨찾기 되었습니다.")
                    } else {
                        owner.view.makeToast("\(element.name)이(가) 즐겨찾기에서 제거되었습니다.")
                    }
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        // 네트워크 단절 or 네트워크 에러
        output.networkDisconnected
            .subscribe(with: self) { owner, message in
                let vc = NetworkPopViewController()
                vc.mainView.retryButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        owner.dismiss(animated: true)
                    })
                    .disposed(by: owner.disposeBag)
                
                vc.mainView.configureMessage(message)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                owner.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
    }
    
}
