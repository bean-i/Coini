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
        let restartNetwork: PublishRelay<Int>
    }
    
    struct Output {
        let coinItems: BehaviorRelay<[Ticker]>
        let networkDisconnected: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // coin 데이터
        let coinItems: BehaviorRelay<[Ticker]> = BehaviorRelay(value: [])
        // 정렬 변수
        let sortBy: BehaviorRelay<(SortStandard, SortStatus)> = BehaviorRelay(value: (.trading, .FALL))
        // 인터넷 연결 상태
        let networkConnected = BehaviorRelay(value: NetworkStatusType.unknown)
        // 인터넷 연결 끊김
        let networkDisConnected = PublishRelay<Void>()
        
        NetworkMonitor.shared.networkStatus
            .subscribe(with: self, onNext: { owner, status in
                print("✅✅✅✅✅✅")
                networkConnected.accept(status)
            })
            .disposed(by: disposeBag)
        
        input.restartNetwork.asObservable()
            .subscribe(with: self) { owner, _ in
                print("뷰모델에서 버튼 탭 감지")
            }
            .disposed(by: disposeBag)
        
        // 화면 진입 + 5초마다 네트워크 통신
        Observable.merge(
            input.viewDidLoadTrigger.asObservable(),
            Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
        )
//        .debug("네트워크 통신 시도 시작")
        .withUnretained(self)
        .flatMapLatest { _ in
            print("현재 연결 상태는..:", networkConnected.value)
            if networkConnected.value == .disconnect || networkConnected.value == .unknown {
                print("인터넷 연결이 안 돼있는 것 같아요!!")
                return Single<[Ticker]>.error(URLError(.notConnectedToInternet))
            } else {
                return UpbitNetworkManager.shared.getTickers(api: .upbitTickers, type: [Ticker].self)
                    .catch { error in
                        print("error 방출됨.")
//                        print(error)
                        return Single.just([Ticker.empty])
                    }
            }
        }
        .map { self.sortedByStandard(value: $0, standard: sortBy.value.0, by: sortBy.value.1) }
        .subscribe(with: self) { owner, value in
            print("1️⃣1️⃣1️⃣통신 완료(성공/실패)1️⃣1️⃣1️⃣")
            coinItems.accept(value)
        } onError: { owner, error in
            networkDisConnected.accept(())
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
            .map {
                self.sortedByStandard(value: coinItems.value, standard: $0.0, by: $0.1)
            }
            .bind(to: coinItems)
            .disposed(by: disposeBag)
        
        return Output(
            coinItems: coinItems,
            networkDisconnected: networkDisConnected
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
