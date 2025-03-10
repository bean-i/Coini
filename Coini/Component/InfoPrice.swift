//
//  InfoPrice.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import SnapKit

final class InfoPrice: BaseView {
    
    let contentStackView = UIStackView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let dateLabel = UILabel()
    
    override func configureHierarchy() {
        contentStackView.addArrangedSubviews(
            titleLabel,
            priceLabel,
            dateLabel
        )
        
        addSubview(contentStackView)
    }
    
    override func configureLayout() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentStackView.axis = .vertical
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .customDarkGray
        
        priceLabel.font = .boldSystemFont(ofSize: 12)
        priceLabel.textColor = .customNavy
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 0
        
        dateLabel.font = .systemFont(ofSize: 9, weight: .regular)
        dateLabel.textColor = .customDarkGray
    }
}
