//
//  APIError.swift
//  Coini
//
//  Created by 이빈 on 3/11/25.
//

import Foundation

enum AFError: Error {
    case invalidURL
    case upbitError(message: APIErrorMessage)
    case afError
    case network
    case geckoError(code: Int)
    
    var description: APIErrorMessage {
        switch self {
        case .afError:
            return APIErrorMessage(
                name: "안내",
                message: "네트워크 통신에 문제가 생겼습니다. 다시 시도해 주세요."
            )
        case .invalidURL:
            return APIErrorMessage(
                name: "안내",
                message: "유효하지 않은 접근입니다. 다시 시도해 주세요."
            )
        case .upbitError(let message):
            return message
        case .network:
            return APIErrorMessage(
                name: "안내",
                message: "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
            )
        case .geckoError(code: let code):
            switch code {
            case 400, 401, 403, 429:
                return APIErrorMessage(name: "안내", message: "잘못된 요청입니다. 다시 시도해 주세요.")
            case 500, 503:
                return APIErrorMessage(name: "안내", message: "서버에서 문제가 발생했습니다. 나중에 다시 시도해 주세요.")
            default:
                return APIErrorMessage(name: "안내", message: "알 수 없는 에러가 발생했습니다. 다시 시도해 주세요.")
            }
        }
    }
}

struct UpbitError: Decodable {
    let error: APIErrorMessage
}

struct APIErrorMessage: Decodable {
    let name: String
    let message: String
}
