//
//  SearchCoin.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import Foundation

struct CoinSearch: Decodable {
    let coins: [DetailCoin]
}

struct DetailCoin: Decodable {
    let name: String
    let symbol: String
    let rank: Int
    let thumb: String
    let large: String
    
    enum CodingKeys: String, CodingKey {
        case name, symbol, thumb, large
        case rank = "market_cap_rank"
    }
}

extension CoinSearch {
    static let empty = CoinSearch(coins: [])
}
