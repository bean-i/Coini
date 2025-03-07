//
//  Router.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation
import Alamofire

enum Router {
    
    case UpbitTickers
    
    var endpoint: URL? {
        switch self {
        case .UpbitTickers:
            return URL(string: UpbitAPI.url + "/v1/ticker/all")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .UpbitTickers:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .UpbitTickers:
            return ["quote_currencies": "KRW"]
        }
    }
    
    
}
