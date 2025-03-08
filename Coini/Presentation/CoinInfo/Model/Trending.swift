//
//  Trending.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation

struct Trending: Decodable {
    let coins: [SearchCoin]
}

struct SearchCoin: Decodable {
    let item: Item
}

struct Item: Decodable {
    let symbol: String
    let name: String
    let thumb: String
    let small: String
    let large: String
    let data: CoinData
}

struct CoinData: Decodable {
    let changePercentage: CoinPercentage
    
    enum CodingKeys: String, CodingKey {
        case changePercentage = "price_change_percentage_24h"
    }
}

struct CoinPercentage: Decodable {
    let krw: Double
}


extension Trending {
    static let empty = Trending(coins: [])
}
