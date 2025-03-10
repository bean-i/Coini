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
        let searchButtonTapped: Observable<String>
        let coinItemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let coinItems: BehaviorRelay<[SearchCoin]>
        let NFTItems: BehaviorRelay<[SearchNFT]>
        let networkTime: BehaviorRelay<Date>
        let searchButtonTapped: Observable<String>
        let selectedCoinItem: PublishRelay<String>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 인기 검색어
        let coinItems: BehaviorRelay<[SearchCoin]> = BehaviorRelay(value: [])
        // 인기 NFT
        let NFTItems: BehaviorRelay<[SearchNFT]> = BehaviorRelay(value: [])
        // 네트워크 통신 시간
        let networkTime: BehaviorRelay<Date> = BehaviorRelay(value: Date())
        // 인기검색어 탭 정보
        let selectedCoinItem = PublishRelay<String>()
        
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
            .map { (Array($0.coins[0..<14]), Array($0.nfts[0..<7])) }
            .subscribe(with: self) { owner, value in
                print("2️⃣2️⃣2️⃣통신 완료(성공/실패)2️⃣2️⃣2️⃣")
                coinItems.accept(value.0)
                NFTItems.accept(value.1)
                networkTime.accept(Date())
            } onError: { owner, error in
                print("error", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        // 인기 검색어 탭
        input.coinItemSelected
            .map { coinItems.value[$0.row].item.id }
            .bind(with: self) { owner, value in
                selectedCoinItem.accept(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            coinItems: coinItems,
            NFTItems: NFTItems,
            networkTime: networkTime,
            searchButtonTapped: input.searchButtonTapped,
            selectedCoinItem: selectedCoinItem
        )
    }
    
}
