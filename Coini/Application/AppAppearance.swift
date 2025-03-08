//
//  AppAppearance.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit

final class AppAppearance {
    
    static func configureAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customNavy]
        UINavigationBar.appearance().tintColor = .customNavy
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
}
