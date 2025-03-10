//
//  SearchDetailViewController.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchDetailViewController: BaseViewController<SearchDetailView> {
    
    let viewModel = SearchDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func bind() {
        let input = SearchDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        // 메인뷰 데이터 나타내기
        output.coinDetailInfo
            .bind(with: self) { owner, value in
                owner.mainView.configureData(data: value)
            }
            .disposed(by: disposeBag)
    }
    
}
