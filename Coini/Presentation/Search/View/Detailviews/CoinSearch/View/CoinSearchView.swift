//
//  CoinSearchView.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import SnapKit

final class CoinSearchView: BaseView {
    
    let coinTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(coinTableView)
    }
    
    override func configureLayout() {
        coinTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        coinTableView.register(CoinSearchTableViewCell.self, forCellReuseIdentifier: CoinSearchTableViewCell.identifier)
    }
    
}
