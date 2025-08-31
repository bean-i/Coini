//
//  Double+.swift
//  Coining
//
//  Created by 이빈 on 3/7/25.
//

import Foundation

extension Double {
    
    // 공통 숫자 표기 방식
    // 정수 -> 세자리마다 쉼표 구분
    // 소수점 -> 소수점 3자리에서 반올림(2자리까지 표시)
    func commonRound() -> Any {
        if self == Double(Int(self)) { // 정수인 경우
            return NumberFormatter.formatted(self as NSNumber) ?? "0.00"
        } else {
            return self.roundSecond()
        }
    }
    
    // 소수점 3자리에서 반올림 -> 소수점 2자리까지 표시
    func roundSecond() -> Double {
        return (self * 100).rounded() / 100
    }
    
    // 반올림 후 소수점 둘째자리가 0인 경우 -> 소수점 1자리까지만 표시
    func removeSecondZero() -> Double {
        let second = (self * 100).rounded()
        if second / 10 == 0 { // 소수점 둘째자리가 0인 경우
            return (second/10) / 100
        } else {
            return second/100
        }
    }
    
    // 100만 단위로 변환
    func convertToMillion() -> String {
        let intValue = Int(self)
        if intValue > 1000000 {
            return "\(NumberFormatter.formatted(intValue/1000000 as NSNumber))百万"
        } else {
            return NumberFormatter.formatted(intValue as NSNumber)
        }
    }
}
