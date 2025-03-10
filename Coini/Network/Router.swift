//
//  Router.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation
import Alamofire

enum Router {
    
    case upbitTickers
    case geckoTrending
    case geckoSearch(keyword: String)
    case geckoCoinMarket(id: String)
    
    var endpoint: URL? {
        switch self {
        case .upbitTickers:
            return URL(string: UpbitAPI.url + "/v1/ticker/all")
        case .geckoTrending:
            return URL(string: GechoAPI.url + "/api/v3/search/trending")
        case .geckoSearch:
            return URL(string: GechoAPI.url + "/api/v3/search")
        case .geckoCoinMarket:
            return URL(string: GechoAPI.url + "/api/v3/coins/markets")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .upbitTickers:
            return .get
        case .geckoTrending:
            return .get
        case .geckoSearch:
            return .get
        case .geckoCoinMarket:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .upbitTickers:
            return ["quote_currencies": "KRW"]
        case .geckoTrending:
            return [:]
        case .geckoSearch(let keyword):
            return ["query": keyword]
        case .geckoCoinMarket(let id):
            return [
                "vs_currency": "krw",
                "ids": id,
                "sparkline": "true"
            ]
        }
    }
}
