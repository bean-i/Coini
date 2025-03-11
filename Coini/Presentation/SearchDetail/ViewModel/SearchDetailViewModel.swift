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
        let viewDidLoadTrigger: Observable<Void>
        let stockMoreButtonTapped: ControlEvent<Void>
        let investMoreButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let viewDidLoadTrigger: Observable<Void>
        let coinDetailInfo: BehaviorRelay<CoinMarket>
        let stockMoreButtonTapped: ControlEvent<Void>
        let investMoreButtonTapped: ControlEvent<Void>
        let networkCompleted: PublishRelay<Bool>
        let networkDisconnected: PublishRelay<APIErrorMessage>
    }
    
    let detailCoinId: BehaviorRelay<String> = BehaviorRelay(value: "bitcoin")
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let coinDetailInfo: BehaviorRelay<CoinMarket> = BehaviorRelay(value: CoinMarket.empty)
        let networkCompleted = PublishRelay<Bool>()
        // 인터넷 연결 상태
        let networkConnected = NetworkMonitor.shared.networkStatus
        // 인터넷 연결 끊김
        let networkDisConnected = PublishRelay<APIErrorMessage>()
        
        detailCoinId
            .distinctUntilChanged()
            .flatMapLatest {
                print("===-----====----====----====----")
                if networkConnected.value == .disconnect || networkConnected.value == .unknown {
                    networkDisConnected.accept(AFError.network.description)
                    return Single<[CoinMarket]>.error(URLError(.notConnectedToInternet))
                } else {
                    return CoingeckoNetworkManager.shared.getTrending(api: .geckoCoinMarket(id: $0), type: [CoinMarket].self)
                        .catch { error in
                            switch error as? AFError {
                            case .afError:
                                networkDisConnected.accept(AFError.afError.description)
                            case .geckoError(let code):
                                networkDisConnected.accept(AFError.geckoError(code: code).description)
                            default:
                                break
                            }
                            return Single.just([CoinMarket.empty])
                        }
                }
            }
            .map { $0.first ?? CoinMarket.empty }
            .subscribe(with: self) { owner, value in
                coinDetailInfo.accept(value)
                networkCompleted.accept(true)
            } onError: { owner, error in
                print("😢", error)
                networkDisConnected.accept(AFError.network.description)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
        return Output(
            viewDidLoadTrigger: input.viewDidLoadTrigger,
            coinDetailInfo: coinDetailInfo,
            stockMoreButtonTapped: input.stockMoreButtonTapped,
            investMoreButtonTapped: input.investMoreButtonTapped,
            networkCompleted: networkCompleted,
            networkDisconnected: networkDisConnected
        )
    }
    
}
