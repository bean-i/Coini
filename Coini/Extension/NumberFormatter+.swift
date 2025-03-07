//
//  NumberFormatter+.swift
//  Coining
//
//  Created by 이빈 on 3/7/25.
//

import Foundation

extension NumberFormatter {
    
    static let formatted = { value in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: value)
    }
    
}
