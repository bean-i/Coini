//
//  CoinInfoViewModel.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinInfoViewModel: BaseViewModel {
    
    struct Input {
        let viewDidLoadTrigger: Observable<Int>
    }
    
    struct Output {
        let coinItems: BehaviorRelay<[SearchCoin]>
        let networkTime: BehaviorRelay<Date>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let coinItems: BehaviorRelay<[SearchCoin]> = BehaviorRelay(value: [])
        let networkTime: BehaviorRelay<Date> = BehaviorRelay(value: Date())
        
        // 화면 진입 + 10분마다 네트워크 통신
        Observable.merge(
            input.viewDidLoadTrigger.asObservable(),
            Observable<Int>.interval(.seconds(600), scheduler: MainScheduler.instance)
        )
            .withUnretained(self)
            .flatMapLatest { _ in
                CoingeckoNetworkManager.shared.getTrending(api: .geckoTrending, type: Trending.self)
                    .catch { error in
                        print("error 방출됨.")
                        //                        print(error)
                        return Single.just(Trending.empty)
                    }
            }
            .map { Array($0.coins[0..<14]) }
            .subscribe(with: self) { owner, value in
                print("2️⃣2️⃣2️⃣통신 완료(성공/실패)2️⃣2️⃣2️⃣")
                coinItems.accept(value)
                networkTime.accept(Date())
            } onError: { owner, error in
                print("error", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            coinItems: coinItems,
            networkTime: networkTime
        )
    }
    
}
