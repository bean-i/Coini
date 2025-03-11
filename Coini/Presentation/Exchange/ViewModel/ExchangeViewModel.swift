//
//  ExchangeViewModel.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ExchangeViewModel: BaseViewModel {
    
    struct Input {
        let viewDidLoadTrigger: Observable<Int>
        let sortButtonTappedValue: Observable<(SortStandard, SortStatus)>
    }
    
    struct Output {
        let coinItems: BehaviorRelay<[Ticker]>
        let networkDisconnected: PublishRelay<APIErrorMessage>
        let showToast: BehaviorRelay<String>
    }
    
    let restartNetwork = BehaviorRelay(value: 0)
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // coin 데이터
        let coinItems: BehaviorRelay<[Ticker]> = BehaviorRelay(value: [Ticker.empty])
        // 정렬 변수
        let sortBy: BehaviorRelay<(SortStandard, SortStatus)> = BehaviorRelay(value: (.trading, .FALL))
        // 인터넷 연결 상태
        let networkConnected = NetworkMonitor.shared.networkStatus
        // 인터넷 연결 끊김
        let networkDisConnected = PublishRelay<APIErrorMessage>()
        let showToast = BehaviorRelay(value: "")
        
        // 화면 진입 + 5초마다 네트워크 통신
        Observable.merge(
            input.viewDidLoadTrigger.asObservable(),
            Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance),
            restartNetwork.asObservable()
        )
        .flatMapLatest { _ in
            if networkConnected.value == .disconnect || networkConnected.value == .unknown {
                showToast.accept("네트워크 통신이 원활하지 않습니다.")
                networkDisConnected.accept(AFError.network.description)
                return Single.just([Ticker.empty])
            } else {
                return UpbitNetworkManager.shared.getTickers(api: .upbitTickers, type: [Ticker].self)
                    .catch { error in
                        switch error as? AFError {
                        case .afError:
                            networkDisConnected.accept(AFError.afError.description)
                        case .invalidURL:
                            networkDisConnected.accept(AFError.invalidURL.description)
                        case .upbitError(let message):
                            networkDisConnected.accept(message)
                        default:
                            break
                        }
                        return Single.just([Ticker.empty])
                    }
            }
        }
        .withUnretained(self)
        .map { owner, result in
            owner.sortedByStandard(value: result, standard: sortBy.value.0, by: sortBy.value.1)
        }
        .subscribe(with: self) { owner, value in
            print("1️⃣1️⃣1️⃣통신 완료(성공/실패)1️⃣1️⃣1️⃣")
            coinItems.accept(value)
        } onError: { owner, error in
            print("error", error)
        } onCompleted: { owner in
            print("onCompleted")
        } onDisposed: { owner in
            print("onDisposed")
        }
        .disposed(by: disposeBag)
        
        // 정렬 버튼 탭 -> 정렬 변수 업데이트
        input.sortButtonTappedValue
            .bind(to: sortBy)
            .disposed(by: disposeBag)
        
        // 기존 데이터 정렬 수행
        sortBy
            .withUnretained(self)
            .map { owner, result in
                owner.sortedByStandard(value: coinItems.value, standard: result.0, by: result.1)
            }
            .bind(to: coinItems)
            .disposed(by: disposeBag)
        
        return Output(
            coinItems: coinItems,
            networkDisconnected: networkDisConnected,
            showToast: showToast
        )
    }
    
    // 정렬
    private func sortedByStandard(value: [Ticker], standard: SortStandard, by: SortStatus) -> [Ticker] {
        switch standard {
        case .current:
            switch by {
            case .EVEN:
                return value
            case .RISE:
                return value.sorted { $0.currentPrice < $1.currentPrice }
            case .FALL:
                return value.sorted { $0.currentPrice > $1.currentPrice }
            }
        case .compared:
            switch by {
            case .EVEN:
                return value
            case .RISE:
                return value.sorted { $0.changeRate < $1.changeRate }
            case .FALL:
                return value.sorted { $0.changeRate > $1.changeRate }
            }
        case .trading:
            switch by {
            case .EVEN:
                return value
            case .RISE:
                return value.sorted { $0.tradePrice < $1.tradePrice }
            case .FALL:
                return value.sorted { $0.tradePrice > $1.tradePrice }
            }
        }
    }
    
}
