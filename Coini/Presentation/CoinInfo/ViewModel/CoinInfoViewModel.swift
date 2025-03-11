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
        let searchButtonTapped: Observable<String>
        let coinItemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let coinItems: BehaviorRelay<[SearchCoin]>
        let NFTItems: BehaviorRelay<[SearchNFT]>
        let networkTime: BehaviorRelay<Date>
        let searchButtonTapped: Observable<String>
        let selectedCoinItem: PublishRelay<String>
        let networkDisconnected: PublishRelay<APIErrorMessage>
    }
    
    let appLoad = Observable.just(())
    let disposeBag = DisposeBag()
    
    init() {
        appLoad
            .flatMapLatest { _ in
                CoingeckoNetworkManager.shared.getTrending(api: .geckoTrending, type: Trending.self)
                    .catch { error in
                        return Single.just(Trending.empty)
                    }
            }
            .map { (Array($0.coins[0..<14]), Array($0.nfts[0..<7])) }
            .subscribe(with: self) { owner, value in
                print("2️⃣2️⃣2️⃣통신 완료(성공/실패)2️⃣2️⃣2️⃣")
                owner.coinItems.accept(value.0)
                owner.NFTItems.accept(value.1)
                owner.networkTime.accept(Date())
            } onError: { owner, error in
                print("error", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
    }
    
    // 인기 검색어
    let coinItems: BehaviorRelay<[SearchCoin]> = BehaviorRelay(value: [])
    // 인기 NFT
    let NFTItems: BehaviorRelay<[SearchNFT]> = BehaviorRelay(value: [])
    // 네트워크 통신 시간
    let networkTime: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    func transform(input: Input) -> Output {
        // 인터넷 연결 상태
        let networkConnected = NetworkMonitor.shared.networkStatus
        // 인터넷 연결 끊김
        let networkDisConnected = PublishRelay<APIErrorMessage>()
        // 인기검색어 탭 정보
        let selectedCoinItem = PublishRelay<String>()
        
        // 10분마다 네트워크 통신
        Observable<Int>.interval(.seconds(600), scheduler: MainScheduler.instance)
        .flatMapLatest { _ in
            print("현재 연결 상태는..:", networkConnected.value)
            if networkConnected.value == .disconnect || networkConnected.value == .unknown {
                print("인터넷 연결이 안 돼있는 것 같아요!!")
                networkDisConnected.accept(AFError.network.description)
                return Single<Trending>.error(URLError(.notConnectedToInternet))
            } else {
                return CoingeckoNetworkManager.shared.getTrending(api: .geckoTrending, type: Trending.self)
                    .catch { error in
                        switch error as? AFError {
                        case .afError:
                            networkDisConnected.accept(AFError.afError.description)
                        case .geckoError(let code):
                            networkDisConnected.accept(AFError.geckoError(code: code).description)
                        default:
                            break
                        }
                        return Single.just(Trending.empty)
                    }
            }
        }
        .map { (Array($0.coins[0..<14]), Array($0.nfts[0..<7])) }
        .subscribe(with: self) { owner, value in
            print("2️⃣2️⃣2️⃣통신 완료(성공/실패)2️⃣2️⃣2️⃣")
            owner.coinItems.accept(value.0)
            owner.NFTItems.accept(value.1)
            owner.networkTime.accept(Date())
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
            .distinctUntilChanged()
            .withUnretained(self)
            .map { owner, index in owner.coinItems.value[index.row].item.id }
            .bind(with: self) { owner, value in
                selectedCoinItem.accept(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            coinItems: coinItems,
            NFTItems: NFTItems,
            networkTime: networkTime,
            searchButtonTapped: input.searchButtonTapped,
            selectedCoinItem: selectedCoinItem,
            networkDisconnected: networkDisConnected
        )
    }
    
}
