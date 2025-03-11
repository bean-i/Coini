//
//  Loading.swift
//  Coini
//
//  Created by 이빈 on 3/11/25.
//

import UIKit

final class Loading {
    
    static let shared = Loading()
    
    private init() { }
    
    func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            
            let contentView = UIView()
            let loadingIndicatorView: UIActivityIndicatorView
            
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                contentView.backgroundColor = .black.withAlphaComponent(0.3)
                contentView.frame = window.frame
                contentView.tag = 1
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .black
                window.addSubViews(contentView, loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView || $0.tag == 1 }).forEach { $0.removeFromSuperview() }
        }
    }
    
}
