//
//  PageCollectionViewCell.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import SnapKit

final class PageCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PageCollectionViewCell"

    let pageView = UIView()
    
    override func configureHierarchy() {
        addSubview(pageView)
    }
    
    override func configureLayout() {
        pageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        pageView.backgroundColor = .customRed
    }
    
    func configureData(data: UIViewController) {
        pageView.addSubview(data.view)
        data.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
