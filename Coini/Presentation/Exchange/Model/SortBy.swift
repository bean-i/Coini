//
//  SortBy.swift
//  Coining
//
//  Created by 이빈 on 3/7/25.
//

import Foundation

enum SortStandard: String {
    case current = "현재가"
    case compared = "전일대비"
    case trading = "거래대금"
}

enum SortStatus: String { // rawValue와 통신 값 비교를 위해 대문자로 표기
    case EVEN
    case RISE
    case FALL
}
