//
//  SearchDetailView.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import SwiftUI
import SnapKit
import Kingfisher

final class SearchDetailView: BaseView {
    
    let navStackView = UIStackView()
    let navImageView = UIImageView()
    let navTitleLabel = UILabel()

    let navButton = StarButton()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let currentPrice = UILabel()
    let statusImageView = UIImageView()
    let statusPercent = UILabel()
    
    let coinChart = PriceChart(chartData: ChartData())
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
        navStackView.addArrangedSubviews(
            navImageView,
            navTitleLabel
        )
        
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
        navImageView.snp.makeConstraints { make in
            make.size.equalTo(26)
        }
        
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
            make.height.equalTo(200)
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
        
        navStackView.axis = .horizontal
        navStackView.spacing = 5
        navStackView.alignment = .center
        
        navImageView.clipsToBounds = true
        navImageView.contentMode = .scaleAspectFit
        navImageView.layer.cornerRadius = 13
        
        navTitleLabel.font = .boldSystemFont(ofSize: 16)
        navTitleLabel.textColor = .customNavy
        
        scrollView.showsVerticalScrollIndicator = false
        
        currentPrice.font = .systemFont(ofSize: 18, weight: .heavy)
        currentPrice.textColor = .customNavy
        
        statusImageView.contentMode = .scaleAspectFill
        statusPercent.font = .boldSystemFont(ofSize: 12)
        
        updateTime.font = .systemFont(ofSize: 9, weight: .regular)
        updateTime.textColor = .customDarkGray
        
        stockInfoHeader.titleLabel.text = "종목정보"
        
        stockView.backgroundColor = .customLightGray
        stockView.layer.cornerRadius = 10
        
        stackView24.axis = .horizontal
        stackView24.spacing = 100
        
        lowPrice24.titleLabel.text = "24시간 고가"
        highPrice24.titleLabel.text = "24시간 저가"
        
        stackViewAllTime.axis = .horizontal
        stackViewAllTime.spacing = 100
        
        allTimeHighPrice.titleLabel.text = "역대 최고가"
        allTimeLowPrice.titleLabel.text = "역대 최저가"
        investInfoHeader.titleLabel.text = "투자지표"
        
        investView.backgroundColor = .customLightGray
        investView.layer.cornerRadius = 10
        
        investPriceStackView.axis = .vertical
        investPriceStackView.spacing = 10
        
        marketCap.titleLabel.text = "시가총액"
        fullDilutedValue.titleLabel.text = "완전 희석 가치(FDV)"
        totalVolume.titleLabel.text = "총 거래량"
    }
    
    func configureNavigation(title: String, image: String, coinID: String) {
        navTitleLabel.text = title
        
        if let url = URL(string: image) {
            navImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "arrowshape.down"))
        } else {
            navImageView.image = UIImage(systemName: "square.3.layers.3d.down.left.slash")
        }
        
        navButton.id = coinID
    }
    
    func configureChart(data: [Double]) {
        coinChart.chartData.chartPrices = data
    }
    
    func configureData(data: CoinMarket) {
        // 현재 가격
        currentPrice.text = "￦\(String(describing: NumberFormatter.formatted(data.currentPrice as NSNumber)))"
        
        // 변동폭
        let change = data.priceChange24h
        if change > 0 {
            statusImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
            statusPercent.text = "\(change.commonRound())%"
            statusImageView.tintColor = .customRed
            statusPercent.textColor = .customRed
        } else if change < 0 {
            statusImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
            statusPercent.text = "\(change.commonRound())%"
            statusImageView.tintColor = .customBlue
            statusPercent.textColor = .customBlue
        } else {
            statusPercent.text = "0.00%"
            statusPercent.textColor = .black
        }
        
        // 업데이트 날짜
        updateTime.text = "\(DateFormatter.monthDayDate(data.lastUpdate)) 업데이트"
        
        // 24시간 고가
        highPrice24.priceLabel.text = "￦\(NumberFormatter.formatted(data.high24h as NSNumber))"
//        highPrice24.priceLabel.text = "32489712347890123407983412890743218970324978"
        
        // 24시간 저가
        lowPrice24.priceLabel.text = "￦\(NumberFormatter.formatted(data.low24h as NSNumber))"
//        lowPrice24.priceLabel.text = "912740938014327812347908432190784321908743218970"
        
        // 역대 최고가
        allTimeHighPrice.priceLabel.text = "￦\(NumberFormatter.formatted(data.allTimeHighPrice as NSNumber))"
        allTimeHighPrice.dateLabel.text = DateFormatter.yearMonthDay(data.allTimeHighPriceDate)

        // 역대 최저가
        allTimeLowPrice.priceLabel.text = "￦\(NumberFormatter.formatted(data.allTimeLowPrice as NSNumber))"
        allTimeLowPrice.dateLabel.text = DateFormatter.yearMonthDay(data.allTimeLowPriceDate)
        
        // 시가총액
        marketCap.priceLabel.text = "￦\(NumberFormatter.formatted(data.marketCap as NSNumber))"
        
        // 완전 희석 가치
        fullDilutedValue.priceLabel.text = "￦\(NumberFormatter.formatted(data.fullyDilutedValue as NSNumber))"
        
        // 총 거래량
        totalVolume.priceLabel.text = "￦\(NumberFormatter.formatted(data.totalVolume as NSNumber))"
    }
    
}
