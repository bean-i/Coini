//
//  ExchangeViewController.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class ExchangeViewController: BaseViewController<ExchangeView> {
    
    private let viewModel = ExchangeViewModel()
    private let disposeBag = DisposeBag()
    
    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "거래소"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .customNavy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    override func bind() {
        let input = ExchangeViewModel.Input(
            viewDidLoadTrigger: Observable.just(0),
            sortButtonTappedValue: Observable.of(
                mainView.currentValueButton.rx.tap.map { SortStandard.current },
                mainView.comparedValueButton.rx.tap.map { SortStandard.compared },
                mainView.tradingValueButton.rx.tap.map { SortStandard.trading }
            )
            .merge()
            .flatMap { [weak self] in
                guard let self else { return Observable.just((SortStandard.trading, SortStatus.FALL)) }
                switch $0 {
                case .current:
                    mainView.comparedValueButton.configureResetStatus()
                    mainView.tradingValueButton.configureResetStatus()
                    let status = mainView.currentValueButton.configureTapStatus()
                    if status == .EVEN {
                        return Observable.just((SortStandard.trading, SortStatus.FALL))
                    } else {
                        return Observable.just((SortStandard.current, status))
                    }
                case .compared:
                    mainView.currentValueButton.configureResetStatus()
                    mainView.tradingValueButton.configureResetStatus()
                    let status = mainView.comparedValueButton.configureTapStatus()
                    if status == .EVEN {
                        return Observable.just((SortStandard.trading, SortStatus.FALL))
                    } else {
                        return Observable.just((SortStandard.compared, status))
                    }
                case .trading:
                    mainView.currentValueButton.configureResetStatus()
                    mainView.comparedValueButton.configureResetStatus()
                    let status = mainView.tradingValueButton.configureTapStatus()
                    if status == SortStatus.EVEN {
                        return Observable.just((SortStandard.trading, SortStatus.FALL))
                    } else {
                        return Observable.just((SortStandard.trading, status))
                    }
                }
            }
        )
        
        let output = viewModel.transform(input: input)
        
        // coin 테이블뷰
        output.coinItems
            .bind(to: mainView.coinTableView.rx.items(cellIdentifier: ExchangeTableViewCell.identifier, cellType: ExchangeTableViewCell.self)) { (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        // 네트워크 단절 or 네트워크 에러
        output.networkDisconnected
            .subscribe(with: self) { [weak self] owner, message in
                guard let self else { return }
                let vc = NetworkPopViewController()
                vc.mainView.retryButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        owner.viewModel.restartNetwork.accept(1)
                        owner.dismiss(animated: true)
                    })
                    .disposed(by: owner.disposeBag)
                
                vc.mainView.configureMessage(message)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                owner.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .bind(with: self) { owner, value in
                owner.view.makeToast(value)
            }
            .disposed(by: disposeBag)
    }
}
