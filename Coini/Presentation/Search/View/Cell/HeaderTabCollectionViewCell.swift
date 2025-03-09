//
//  HeaderTabCollectionViewCell.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import SnapKit

final class HeaderTabCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "HeaderTabCollectionViewCell"
    
    let titleLabel = UILabel()
    let underLineView = UIView()
    
    override func configureHierarchy() {
        contentView.addSubViews(
            titleLabel,
            underLineView
        )
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 14) //
        titleLabel.textColor = .customDarkGray
        
        underLineView.backgroundColor = .customDarkGray
    }
    
    func configureData(data: HeaderItem) {
        titleLabel.text = data.title
        
        if data.isSelected {
            titleLabel.textColor = .customNavy
            underLineView.backgroundColor = .customNavy
            underLineView.snp.updateConstraints { make in
                make.height.equalTo(2)
            }
        } else {
            titleLabel.textColor = .customDarkGray
            underLineView.backgroundColor = .customDarkGray
            underLineView.snp.updateConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
    
}
