//
//  ExchangeModel.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation

struct Ticker: Decodable {
    let market: String
    let currentPrice: Double // 현재가
    let changeStatus: String // 상승?하락?
    let changePrice: Double // 전일대비 변화액
    let changeRate: Double // 전일대비 변화율
    let tradePrice: Double // 24시간 누적 거래대금
    
    enum CodingKeys: String, CodingKey {
        case market
        case currentPrice = "trade_price"
        case changeStatus = "change"
        case changePrice = "signed_change_price"
        case changeRate = "signed_change_rate"
        case tradePrice = "acc_trade_price_24h"
    }
}

extension Ticker {
    static let empty = Ticker(
        market: "empty",
        currentPrice: 0,
        changeStatus: "empty",
        changePrice: 0.00,
        changeRate: 0,
        tradePrice: 0
    )
}
