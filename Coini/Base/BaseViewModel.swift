//
//  BaseViewModel.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
