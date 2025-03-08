//
//  SearchViewController.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import RxSwift
import RxCocoa

struct HeaderItem {
    var isSelected: Bool
    let title: String
}

final class SearchViewController: BaseViewController<SearchView> {
    
    let disposeBag = DisposeBag()

    override func configureNavigation() {
        navigationItem.leftBarButtonItems = [
            mainView.backButton,
            UIBarButtonItem(customView: mainView.searchTextField)
        ]
        
    }
    
    override func bind() {
        
        mainView.backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
 
        let items = [
            HeaderItem(isSelected: true, title: "코인"),
            HeaderItem(isSelected: false, title: "NFT"),
            HeaderItem(isSelected: false, title: "거래소")
        ]
        
        let headerItems = BehaviorRelay(value: items)
        var updatedItems = headerItems.value
        
        headerItems
            .bind(to: mainView.headerTabCollectionView.rx.items(cellIdentifier: HeaderTabCollectionViewCell.identifier, cellType: HeaderTabCollectionViewCell.self)) { (row, element, cell) in
                print("🔥🔥🔥🔥🔥")
                print(element)
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)

        // 셀을 표현할 때, isSelected랑 title을 같이 넘겨줘서 표현하고
        // isSelected랑 title을 한번에 갖고있는 데이터타입을 만들어서
        // itemSelected되면 해당 데이터타입을 변경. -> 그럼 자동으로 데이터타입을 구독하고 있기 때문에 컬렉션뷰가 업데이트 되지 않을까?
        mainView.headerTabCollectionView.rx.itemSelected
            .map { item in
                for index in 0..<updatedItems.count {
                    if index == item.item {
                        updatedItems[index].isSelected = true
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
        
    }
    
    
}
