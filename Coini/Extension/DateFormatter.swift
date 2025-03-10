//
//  DateFormatter.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation

extension DateFormatter {
    
    static let networkTime = { date in
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm 기준"
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    // ISO문자열 -> Date
    static let isoStringToDate = { str in
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let result = formatter.date(from: str) else {
            return Date()
        }
        return result
    }
    
    // ISO문자열 -> Date -> 년월일 문자열
    static let yearMonthDay = { str in
        let date = DateFormatter.isoStringToDate(str)
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 M월 d일"
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    // ISO문자열 -> Date -> 월/일 시간 문자열
    static let monthDayDate = { str in
        let date = DateFormatter.isoStringToDate(str)
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d hh:mm:ss"
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
}
