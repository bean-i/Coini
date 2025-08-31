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
        firstVC.tabBarItem.title = "取引所"
        firstVC.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        let secondVC = CoinInfoViewController()
        secondVC.tabBarItem.title = "コイン情報"
        secondVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill")
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = PortfolioViewController()
        thirdVC.tabBarItem.title = "ポートフォリオ"
        thirdVC.tabBarItem.image = UIImage(systemName: "star")
        let thirdNav = UINavigationController(rootViewController: thirdVC)
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
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
