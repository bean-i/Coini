//
//  InfoHeader.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import UIKit
import SnapKit

final class InfoHeader: BaseView {
    
    let infoStackView = UIStackView()
    let titleLabel = UILabel()
    let moreButton = UIButton()
    
    override func configureHierarchy() {
        infoStackView.addArrangedSubviews(
            titleLabel,
            moreButton
        )
        
        addSubview(infoStackView)
    }
    
    override func configureLayout() {
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fill
        
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = .customNavy
        
        moreButton.setTitle("더보기", for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        moreButton.setTitleColor(.customDarkGray, for: .normal)
        moreButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        moreButton.semanticContentAttribute = .forceRightToLeft
        moreButton.tintColor = .customDarkGray
    }

}
