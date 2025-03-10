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
        guard let result = formatter.string(from: value) else {
            return "0.00"
        }
        return result
    }
    
}
