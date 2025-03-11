//
//  ExchangeTableViewCell.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit
import SnapKit

final class ExchangeTableViewCell: BaseTableViewCell {

    static let identifier = "ExchangeTableViewCell"
    
    private let coinStackView = UIStackView()
    private let titleLabel = UILabel()
    private let currentValue = UILabel()
    
    private let comparedView = UIView()
    private let comparedPercent = UILabel()
    private let comparedValue = UILabel()
    
    private let tradingValue = UILabel()
    
    override func configureHierarchy() {
        comparedView.addSubViews(
            comparedPercent,
            comparedValue
        )
        
        coinStackView.addArrangedSubviews(
            titleLabel,
            currentValue,
            comparedView,
            tradingValue
        )
        
        contentView.addSubview(coinStackView)
    }
    
    override func configureLayout() {
        coinStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        comparedPercent.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        comparedValue.snp.makeConstraints { make in
            make.top.equalTo(comparedPercent.snp.bottom)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        coinStackView.axis = .horizontal
        coinStackView.distribution = .fillEqually
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .customNavy
        titleLabel.font = .boldSystemFont(ofSize: 12)
        
        currentValue.textAlignment = .right
        currentValue.textColor = .customNavy
        currentValue.font = .systemFont(ofSize: 12, weight: .regular)
        
        comparedPercent.textAlignment = .right
        comparedPercent.textColor = .customNavy
        comparedPercent.font = .systemFont(ofSize: 12, weight: .regular)
        
        comparedValue.textAlignment = .right
        comparedValue.textColor = .customNavy
        comparedValue.font = .systemFont(ofSize: 9, weight: .regular)
        
        tradingValue.textAlignment = .right
        tradingValue.textColor = .customNavy
        tradingValue.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    func configureData(data: Ticker) {
        // 마켓
        let newMarket = data.market.split(separator: "-")
        if newMarket.count >= 2 {
            titleLabel.text = "\(newMarket[1])/\(newMarket[0])"
        }

        // 현재가
        if data.currentPrice == Double(Int(data.currentPrice)) {
            currentValue.text = NumberFormatter.formatted(data.currentPrice as NSNumber)
        } else {
            currentValue.text = "\(data.currentPrice.removeSecondZero())"
        }

        // 전일대비
        switch data.changeStatus {
        case SortStatus.EVEN.rawValue:
            configureEvenStatus()
        case SortStatus.RISE.rawValue:
            configureRiseStatus(rate: data.changeRate, value: data.changePrice)
        case SortStatus.FALL.rawValue:
            configureFallStatus(rate: data.changeRate, value: data.changePrice)
        default:
            return
        }
        // 거래대금
        tradingValue.text = data.tradePrice.convertToMillion()
    }
    
    private func configureEvenStatus() {
        comparedPercent.textColor = .black
        comparedValue.textColor = .black
        comparedPercent.text = "0.00%"
        comparedValue.text = "0"
    }
    
    private func configureRiseStatus(rate: Double, value: Double) {
        comparedPercent.textColor = .customRed
        comparedValue.textColor = .customRed
        comparedPercent.text = "\(rate.commonRound())%"
        comparedValue.text = "\(value.commonRound())"
    }
    
    private func configureFallStatus(rate: Double, value: Double) {
        comparedPercent.textColor = .customBlue
        comparedValue.textColor = .customBlue
        comparedPercent.text = "\(rate.commonRound())%"
        comparedValue.text = "\(value.commonRound())"
    }
    
}
