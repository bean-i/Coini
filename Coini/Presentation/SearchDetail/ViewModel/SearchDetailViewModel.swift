//
//  SearchDetailViewModel.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchDetailViewModel: BaseViewModel {
    
    struct Input {
        let stockMoreButtonTapped: ControlEvent<Void>
        let investMoreButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let coinDetailInfo: BehaviorRelay<CoinMarket>
        let stockMoreButtonTapped: ControlEvent<Void>
        let investMoreButtonTapped: ControlEvent<Void>
    }
    
    let detailCoinId: BehaviorRelay<String> = BehaviorRelay(value: "bitcoin")
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let coinDetailInfo: BehaviorRelay<CoinMarket> = BehaviorRelay(value: CoinMarket.empty)
        
        detailCoinId
            .distinctUntilChanged()
            .flatMapLatest {
                CoingeckoNetworkManager.shared.getTrending(api: .geckoCoinMarket(id: $0), type: [CoinMarket].self)
                    .catch { _ in
                        return Single.just([CoinMarket.empty])
                }
            }
            .map { $0.first ?? CoinMarket.empty }
            .subscribe(with: self) { owner, value in
                coinDetailInfo.accept(value)
            } onError: { owner, error in
                print(error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
        return Output(
            coinDetailInfo: coinDetailInfo,
            stockMoreButtonTapped: input.stockMoreButtonTapped,
            investMoreButtonTapped: input.investMoreButtonTapped
        )
    }
    
}
