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
    
    var endpoint: URL? {
        switch self {
        case .upbitTickers:
            return URL(string: UpbitAPI.url + "/v1/ticker/all")
        case .geckoTrending:
            return URL(string: GechoAPI.url + "/api/v3/search/trending")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .upbitTickers:
            return .get
        case .geckoTrending:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .upbitTickers:
            return ["quote_currencies": "KRW"]
        case .geckoTrending:
            return [:]
        }
    }
    
    
}
