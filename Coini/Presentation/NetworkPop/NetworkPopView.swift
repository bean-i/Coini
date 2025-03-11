//
//  NetworkPopView.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import SnapKit

final class NetworkPopView: BaseView {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let lineView = UIView()
    let retryButton = UIButton()
    
    override func configureHierarchy() {
        containerView.addSubViews(
            titleLabel,
            messageLabel,
            lineView,
            retryButton
        )
        addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        backgroundColor = .black.withAlphaComponent(0.3)
        
        containerView.backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = .customNavy
        
        messageLabel.font = .systemFont(ofSize: 12, weight: .regular)
        messageLabel.textColor = .customNavy
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        lineView.backgroundColor = .customDarkGray
        
        retryButton.setTitle("다시 시도하기", for: .normal)
        retryButton.setTitleColor(.customNavy, for: .normal)
        retryButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    func configureMessage(_ message: APIErrorMessage) {
        titleLabel.text = message.name
        messageLabel.text = message.message
    }
    
}
