//
//  SearchViewModel.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    struct Input {
        let bacButtonTapped: ControlEvent<Void>
        let tabSelected: ControlEvent<IndexPath>
        let swipe: Observable<CGFloat>
    }
    
    struct Output {
        let bacButtonTapped: ControlEvent<Void>
        let headerItems: BehaviorRelay<[HeaderItem]>
        let currentIndex: BehaviorRelay<Int>
        let detailViews: BehaviorRelay<[UIViewController]>
    }
    
    let headerItems = [
        HeaderItem(isSelected: true, title: "코인"),
        HeaderItem(isSelected: false, title: "NFT"),
        HeaderItem(isSelected: false, title: "거래소")
    ]
    let detailViews = [aViewController(), bViewController()]
    var deviceWidth: CGFloat = 1
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let headerItems = BehaviorRelay(value: headerItems)
        var updatedItems = headerItems.value
        // 자동 스크롤
        let currentIndex = BehaviorRelay(value: 0)
        
        let changedIndex = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
        // 헤더탭 선택 -> changedIndex에 전달
        input.tabSelected
            .bind(with: self) { owner, index in
                changedIndex.accept(index)
            }
            .disposed(by: disposeBag)
        
        // 페이지뷰 스와이프 -> changedIndex 값 업데이트
        //: 다음 화면에 완전히 도착해야 헤더탭 ui가 변함 사용자 입장에서 딜레이가 조금 있어보인다..
        input.swipe
            .withUnretained(self)
            .map { owner, point in
                Int(round(point / owner.deviceWidth))
            }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, index in
                changedIndex.accept(IndexPath(item: index, section: 0))
            })
            .disposed(by: disposeBag)
        
        // 바뀐 인덱스로 헤더탭의 데이터 변경
        // headerItems 업데이트: 뷰컨에서 헤더탭 UI 업데이트
        // currentIndex 업데이트: 뷰컨에서 자동 스크롤
        changedIndex
            .map { item in
                print("인덱스 받았어뵤", item)
                for index in 0..<updatedItems.count {
                    if index == item.item {
                        updatedItems[index].isSelected = true
                        currentIndex.accept(index)
                    } else {
                        updatedItems[index].isSelected = false
                    }
                }
                return updatedItems
            }
            .bind(with: self) { owner, items in
                headerItems.accept(items)
            }
            .disposed(by: disposeBag)
        
        return Output(
            bacButtonTapped: input.bacButtonTapped,
            headerItems: headerItems,
            currentIndex: currentIndex,
            detailViews: BehaviorRelay(value: detailViews)
        )
    }
    
}
