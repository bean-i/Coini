//
//  SortButton.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import UIKit
import SnapKit

final class SortButton: UIButton {

    var buttonStatus: SortStatus = .EVEN
    
    private let sortLabel = UILabel()
    private let imageContentView = UIView()
    let upImageView = UIImageView()
    let downImageView = UIImageView()
    
    private var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        imageContentView.addSubViews(
            upImageView,
            downImageView
        )
        addSubViews(
            sortLabel,
            imageContentView
        )
    }
    
    private func configureLayout() {
        sortLabel.snp.makeConstraints { make in
            make.trailing.equalTo(imageContentView.snp.leading).inset(-2)
            make.centerY.equalToSuperview()
        }
        
        imageContentView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
        
        upImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
        
        downImageView.snp.makeConstraints { make in
            make.top.equalTo(upImageView.snp.bottom).inset(4)
            make.bottom.horizontalEdges.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
    }
    
    private func configureView() {
        sortLabel.font = .systemFont(ofSize: 12, weight: .bold)
        sortLabel.textColor = .customNavy
        sortLabel.text = text
        
        upImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        upImageView.tintColor = .customDarkGray
        
        downImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        downImageView.tintColor = .customDarkGray
    }
    
    // 현재 상태에 따라 상태 변경
    func configureTapStatus() {
        switch buttonStatus {
        case .EVEN:
            buttonStatus = .FALL
        case .RISE:
            buttonStatus = .EVEN
        case .FALL:
            buttonStatus = .RISE
        }
        
        configureTapUI(status: buttonStatus)
    }
    
    func configureTapUI(status: SortStatus) {
        switch status {
        case .EVEN:
            upImageView.tintColor = .customDarkGray
            downImageView.tintColor = .customDarkGray
        case .RISE:
            upImageView.tintColor = .customNavy
            downImageView.tintColor = .customDarkGray
        case .FALL:
            upImageView.tintColor = .customDarkGray
            downImageView.tintColor = .customNavy
        }
    }
    
    // 상태 초기화
    func configureResetStatus() {
        buttonStatus = .EVEN
        upImageView.tintColor = .customDarkGray
        downImageView.tintColor = .customDarkGray
    }
    
}
