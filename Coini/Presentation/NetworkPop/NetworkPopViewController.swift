//
//  NetworkPopViewController.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class NetworkPopViewController: BaseViewController<NetworkPopView> {
    
    let disposeBag = DisposeBag()
    
    override func bind() {
        
        mainView.retryButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}
