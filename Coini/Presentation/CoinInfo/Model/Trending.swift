//
//  Trending.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation

// MARK: - Trending API Model
struct Trending: Decodable {
    let coins: [SearchCoin]
    let nfts: [SearchNFT]
}

// MARK: - NFT
struct SearchNFT: Decodable {
    let name: String
    let thumb: String
    let data: NFTData
}

struct NFTData: Decodable {
    let floorPrice: String
    let floorPercentage: String
    
    enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
        case floorPercentage = "floor_price_in_usd_24h_percentage_change"
    }
}

// MARK: - Coin
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

// MARK: - Dummy
extension Trending {
    static let empty = Trending(
        coins: [],
        nfts: []
    )
}
