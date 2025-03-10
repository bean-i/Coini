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
    }
    
    let searchKeyword = BehaviorRelay(value: "empty")
    let detailCoinId = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 통신 결과
        let searchResults: BehaviorRelay<[DetailCoin]> = BehaviorRelay(value: [])
        
        // searchKeyword로 네트워크 통신
        // 데이터모델은 CoinSearch
        searchKeyword
            .flatMapLatest { keyword in
                CoingeckoNetworkManager.shared.getTrending(api: .geckoSearch(keyword: keyword), type: CoinSearch.self)
                    .catch { error in
                        print("error 방출됨.")
                        return Single.just(CoinSearch.empty)
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
        
        return Output(searchResults: searchResults)
    }
    
}
