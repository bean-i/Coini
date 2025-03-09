//
//  PortfolioViewController.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit

final class PortfolioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    private func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "포트폴리오"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .customNavy
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

}
