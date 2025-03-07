//
//  CoiniTabBarController.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit

final class CoiniTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        configureTabBarAppearance()
    }
    
    private func configureTabBarController() {
        let firstVC = ExchangeViewController()
        firstVC.tabBarItem.title = "거래소"
        firstVC.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        setViewControllers([firstNav], animated: true)
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.customNavy]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .customNavy
    }
    
    
}
