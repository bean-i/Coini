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
    
}
