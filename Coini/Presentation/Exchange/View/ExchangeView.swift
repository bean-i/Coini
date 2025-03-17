//
//  ExchangeView.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit
import SnapKit

final class ExchangeView: BaseView {
    
    // 정렬 UI
    private let sortView = UIView()
    private let sortStackView = UIStackView()
    private let coinLabel = UILabel()
    let currentValueButton = SortButton(text: "현재가")
    let comparedValueButton = SortButton(text: "전일대비")
    let tradingValueButton = SortButton(text: "거래대금")
    
    // 테이블뷰
    let coinTableView = UITableView()
    
    override func configureHierarchy() {
        sortStackView.addArrangedSubviews(
            coinLabel,
            currentValueButton,
            comparedValueButton,
            tradingValueButton
        )
        
        sortView.addSubview(sortStackView)
        
        addSubViews(
            sortView,
            coinTableView
        )
    }
    
    override func configureLayout() {
        sortView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview()
        }

        coinTableView.snp.makeConstraints { make in
            make.top.equalTo(sortView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        sortView.backgroundColor = .customLightGray
        
        sortStackView.axis = .horizontal
        sortStackView.distribution = .fillEqually
        
        coinLabel.text = "코인"
        coinLabel.font = .systemFont(ofSize: 12, weight: .bold)
        coinLabel.textColor = .customNavy
        coinLabel.textAlignment = .left
        
        coinTableView.backgroundColor = .clear
        coinTableView.separatorStyle = .none
        coinTableView.allowsSelection = false
        coinTableView.showsVerticalScrollIndicator = false
        coinTableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: ExchangeTableViewCell.identifier)
        
        currentValueButton.buttonStandard = .current
        comparedValueButton.buttonStandard = .compared
        tradingValueButton.buttonStandard = .trading
    }
    
}
