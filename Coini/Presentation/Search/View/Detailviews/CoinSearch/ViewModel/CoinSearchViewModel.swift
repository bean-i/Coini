//
//  CoinSearchViewModel.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinSearchViewModel: BaseViewModel {
    
    struct Input {
        let coinSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let searchResults: BehaviorRelay<[DetailCoin]>
        let updateData: BehaviorRelay<[DetailCoin]>
        let networkDisconnected: PublishRelay<APIErrorMessage>
    }
    
    let searchKeyword = BehaviorRelay(value: "empty")
    let updateDataTrigger: BehaviorRelay<Void> = BehaviorRelay(value: ())
    let detailCoinId = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 인터넷 연결 상태
        let networkConnected = NetworkMonitor.shared.networkStatus
        // 인터넷 연결 끊김
        let networkDisConnected = PublishRelay<APIErrorMessage>()
        // 통신 결과
        let searchResults: BehaviorRelay<[DetailCoin]> = BehaviorRelay(value: [])
        
        let updateData: BehaviorRelay<[DetailCoin]> = BehaviorRelay(value: [])
        // searchKeyword로 네트워크 통신
        // 데이터모델은 CoinSearch
        searchKeyword
            .flatMapLatest { keyword in
                if networkConnected.value == .disconnect || networkConnected.value == .unknown {
                    networkDisConnected.accept(AFError.network.description)
                    return Single<CoinSearch>.error(URLError(.notConnectedToInternet))
                } else {
                    return CoingeckoNetworkManager.shared.getTrending(api: .geckoSearch(keyword: keyword), type: CoinSearch.self)
                        .catch { error in
                            switch error as? AFError {
                            case .afError:
                                networkDisConnected.accept(AFError.afError.description)
                            case .geckoError(let code):
                                networkDisConnected.accept(AFError.geckoError(code: code).description)
                            default:
                                break
                            }
                            return Single.just(CoinSearch.empty)
                        }
                }
            }
            .subscribe(with: self) { owner, value in
                print("3️⃣3️⃣3️⃣통신 완료(성공/실패)3️⃣3️⃣3️⃣")
                searchResults.accept(value.coins)
            } onError: { owner, error in
                print("error", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        // 테이블뷰 탭
        input.coinSelected
            .map { searchResults.value[$0.row].id }
            .bind(with: self) { owner, value in
                owner.detailCoinId.accept(value)
            }
            .disposed(by: disposeBag)
        
        updateDataTrigger
            .bind(with: self) { owner, _ in
                updateData.accept(searchResults.value) // 기존 데이터 그대로 반환
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchResults: searchResults,
            updateData: updateData,
            networkDisconnected: networkDisConnected
        )
    }
    
}
