//
//  SearchDetailView.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import SwiftUI
import SnapKit

final class SearchDetailView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let currentPrice = UILabel()
    let statusImageView = UIImageView()
    let statusPercent = UILabel()
    
    let coinChart = PriceChart(test:"안녕")
    lazy var hostingController = UIHostingController(rootView: coinChart)

    let updateTime = UILabel()
    
    let stockInfoHeader = InfoHeader()
    let stockView = UIView()
    let stackView24 = UIStackView()
    let lowPrice24 = InfoPrice()
    let highPrice24 = InfoPrice()
    let stackViewAllTime = UIStackView()
    let allTimeHighPrice = InfoPrice()
    let allTimeLowPrice = InfoPrice()
    
    let investInfoHeader = InfoHeader()
    let investView = UIView()
    let investPriceStackView = UIStackView()
    let marketCap = InfoPrice()
    let fullDilutedValue = InfoPrice()
    let totalVolume = InfoPrice()
    
    override func configureHierarchy() {
        stackView24.addArrangedSubviews(
            lowPrice24,
            highPrice24
        )
        
        stackViewAllTime.addArrangedSubviews(
            allTimeHighPrice,
            allTimeLowPrice
        )
        
        stockView.addSubViews(
            stackView24,
            stackViewAllTime
        )
        
        investPriceStackView.addArrangedSubviews(
            marketCap,
            fullDilutedValue,
            totalVolume
        )
        
        investView.addSubViews(
            investPriceStackView
        )
        
        contentView.addSubViews(
            currentPrice,
            statusImageView,
            statusPercent,
            hostingController.view,
            updateTime,
            stockInfoHeader,
            stockView,
            investInfoHeader,
            investView
        )
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalTo(scrollView)
            make.bottom.equalTo(investView.snp.bottom).offset(20)
        }
        
        currentPrice.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().inset(20)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.top.equalTo(currentPrice.snp.bottom).offset(3)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
        
        statusPercent.snp.makeConstraints { make in
            make.top.equalTo(currentPrice.snp.bottom).offset(3)
            make.leading.equalTo(statusImageView.snp.trailing).offset(3)
        }
        
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(statusPercent.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        updateTime.snp.makeConstraints { make in
            make.top.equalTo(hostingController.view.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(20)
        }
        
        stockInfoHeader.snp.makeConstraints { make in
            make.top.equalTo(updateTime.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        stockView.snp.makeConstraints { make in
            make.top.equalTo(stockInfoHeader.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(stackViewAllTime.snp.bottom).offset(20)
        }
        
        stackView24.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        stackViewAllTime.snp.makeConstraints { make in
            make.top.equalTo(stackView24.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        investInfoHeader.snp.makeConstraints { make in
            make.top.equalTo(stockView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        investView.snp.makeConstraints { make in
            make.top.equalTo(investInfoHeader.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(investPriceStackView.snp.bottom).offset(20)
        }
        
        investPriceStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        
        scrollView.showsVerticalScrollIndicator = false
        
        currentPrice.font = .boldSystemFont(ofSize: 16)
        currentPrice.textColor = .customNavy
        currentPrice.text = "dksjlakjdlskjdfl;kj"
        
        statusImageView.contentMode = .scaleAspectFill
        statusImageView.image = UIImage(systemName: "star")
        statusImageView.tintColor = .customBlue
        
        statusPercent.font = .boldSystemFont(ofSize: 9)
        statusPercent.text = "0.98%"
        statusPercent.textColor = .customBlue
        
        hostingController.view.backgroundColor = .customRed
        
        updateTime.text = "a;lsdkjfldjqq"
        updateTime.font = .systemFont(ofSize: 9, weight: .regular)
        updateTime.textColor = .customDarkGray
        
        stockInfoHeader.titleLabel.text = "종목정보"
        
        stockView.backgroundColor = .customLightGray
        stockView.layer.cornerRadius = 10
        
        stackView24.axis = .horizontal
        stackView24.spacing = 100
        
        lowPrice24.titleLabel.text = "24시간 고가"
        lowPrice24.priceLabel.text = "1238712893"
        
        highPrice24.titleLabel.text = "24시간 저가"
        highPrice24.priceLabel.text = "1238712893"
        
        stackViewAllTime.axis = .horizontal
        stackViewAllTime.spacing = 100
        
        allTimeHighPrice.titleLabel.text = "역대 최고가"
        allTimeHighPrice.priceLabel.text = "1238712893"
        allTimeHighPrice.dateLabel.text = "25년 1월 20일"
        
        allTimeLowPrice.titleLabel.text = "역대 최저가"
        allTimeLowPrice.priceLabel.text = "1238712893"
        allTimeLowPrice.dateLabel.text = "25년 1월 20일"
        
        investInfoHeader.titleLabel.text = "투자지표"
        
        investView.backgroundColor = .customLightGray
        investView.layer.cornerRadius = 10
        
        investPriceStackView.axis = .vertical
        investPriceStackView.spacing = 10
        
        marketCap.titleLabel.text = "시가총액"
        marketCap.priceLabel.text = "129837492"
        
        fullDilutedValue.titleLabel.text = "완전 희석 가치(FDV)"
        fullDilutedValue.priceLabel.text = "389741298743897432987"
        
        totalVolume.titleLabel.text = "총 거래량"
        totalVolume.priceLabel.text = "23804395908543"
        
    }
    
}
