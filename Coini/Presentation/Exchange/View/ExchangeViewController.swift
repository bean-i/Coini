//
//  ExchangeViewController.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ExchangeViewController: BaseViewController<ExchangeView> {
    
    private let viewModel = ExchangeViewModel()
    private let disposeBag = DisposeBag()
    
    deinit {
        print("ExchangeViewController Deinit")
    }
    
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
        
        // 네트워크 통신 성공 -> 화면 내리기
//        output.coinItems
//            .bind(with: self) { owner, _ in
//                owner.dismiss(animated: true)
//            }
//            .disposed(by: disposeBag)
//        
        // 네트워크 단절 or 네트워크 에러
        output.networkDisconnected
            .subscribe(with: self) { owner, message in
                print("💕💕💕💕💕💕")
                let vc = NetworkPopViewController()
                vc.mainView.retryButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in
//                        restartButton.accept(0)
                        owner.viewModel.restartNetwork.accept(1)
                        owner.dismiss(animated: true)
                    })
                    .disposed(by: owner.disposeBag)
                
                vc.mainView.configureMessage(message)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                owner.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
//        restartButton.subscribe(with: self) { owner, _ in
//            print("재시작 버튼 탭")
//        }
//        .disposed(by: disposeBag)
    }
}
