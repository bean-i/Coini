//
//  CoinMarket.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import Foundation

struct CoinMarket: Decodable {
    let id: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChange24h: Double
    let lastUpdate: String
    let low24h: Double
    let high24h: Double
    let allTimeHighPrice: Double
    let allTimeHighPriceDate: String
    let allTimeLowPrice: Double
    let allTimeLowPriceDate: String
    let marketCap: Int
    let fullyDilutedValue: Int
    let totalVolume: Int
    let sparkline: SparkLinePrice
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case currentPrice = "current_price"
        case priceChange24h = "price_change_percentage_24h"
        case lastUpdate = "last_updated"
        case low24h = "low_24h"
        case high24h = "high_24h"
        case allTimeHighPrice = "ath"
        case allTimeHighPriceDate = "ath_date"
        case allTimeLowPrice = "atl"
        case allTimeLowPriceDate = "atl_date"
        case marketCap = "market_cap"
        case fullyDilutedValue = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case sparkline = "sparkline_in_7d"
    }
}

struct SparkLinePrice: Decodable {
    let price: [Double]
}

extension CoinMarket {
    static let empty = CoinMarket(
        id: "empty",
        name: "empty",
        image: "empty",
        currentPrice: 0,
        priceChange24h: 0,
        lastUpdate: "empty",
        low24h: 0,
        high24h: 0,
        allTimeHighPrice: 0,
        allTimeHighPriceDate: "empty",
        allTimeLowPrice: 0,
        allTimeLowPriceDate: "empty",
        marketCap: 0,
        fullyDilutedValue: 0,
        totalVolume: 0,
        sparkline: SparkLinePrice(price: [])
    )
}
