//
//  UIStackView+.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
