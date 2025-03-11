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
            viewDidLoadTrigger: Observable.just(()),
            stockMoreButtonTapped: mainView.stockInfoHeader.moreButton.rx.tap,
            investMoreButtonTapped: mainView.investInfoHeader.moreButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // 네트워크 단절 or 네트워크 에러
        output.networkDisconnected
            .subscribe(with: self) { owner, message in
                print("네트워크 단절")
                Loading.shared.hideLoading()
                let vc = NetworkPopViewController()
                vc.mainView.retryButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        owner.dismiss(animated: true)
                    })
                    .disposed(by: owner.disposeBag)
                
                vc.mainView.configureMessage(message)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                owner.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        // 뷰디드로드 -> 인디케이터 show
        output.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                Loading.shared.showLoading()
            }
            .disposed(by: disposeBag)
        
        // 통신 완료 -> 인디케이터 hide
        output.networkCompleted
            .bind(with: self) { owner, _ in
                Loading.shared.hideLoading()
            }
            .disposed(by: disposeBag)
        
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
