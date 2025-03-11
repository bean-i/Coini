//
//  StarButton.swift
//  Coini
//
//  Created by 이빈 on 3/11/25.
//

import UIKit

final class StarButton: UIButton {
    
    var id: String = "" {
        didSet {
            if repository.isExist(coinID: id) {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
    
    let repository: LikedService = LikedRepository()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        self.setImage(UIImage(systemName: "star"), for: .normal)
        self.setImage(UIImage(systemName: "star.fill"), for: .selected)
        tintColor = .customNavy
    }

    func updateStatus() {
        isSelected.toggle()

        let new = Liked(coinID: id, isSelected: isSelected)
        
        if isSelected { // true -> 저장
            repository.create(data: new)
        } else { // false -> 삭제
            repository.delete(coinID: id)
        }
    }
    
}
