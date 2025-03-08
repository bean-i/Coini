//
//  KeywordCollectionViewCell.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import SnapKit
import Kingfisher

final class KeywordCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "KeywordCollectionViewCell"
    
    let rankLabel = UILabel()
    
    let imageView = UIImageView()
    
    let titleContentView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    let statusimageView = UIImageView()
    let statusPercentLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubViews(
            rankLabel,
            imageView,
            titleLabel,
            subTitleLabel,
            statusimageView,
            statusPercentLabel
        )
    }
    
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(statusimageView.snp.leading).inset(-2)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(statusimageView.snp.leading).inset(-2)
        }
        
        statusimageView.snp.makeConstraints { make in
            make.trailing.equalTo(statusPercentLabel.snp.leading).inset(-3)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
        
        statusPercentLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        
        rankLabel.font = .systemFont(ofSize: 12, weight: .regular)
        rankLabel.textColor = .customNavy
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 13
        imageView.tintColor = .black
        
        titleContentView.backgroundColor = .red
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = .customNavy
        
        subTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subTitleLabel.font = .systemFont(ofSize: 9, weight: .regular)
        subTitleLabel.textColor = .customDarkGray
        
        statusPercentLabel.font = .boldSystemFont(ofSize: 9)
    }
    
    func configureData(row: Int, data: SearchCoin) {
        rankLabel.text = "\(row + 1)"
        
        // 이미지
        if let url = URL(string: data.item.small) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "arrowshape.down"))
        } else {
            imageView.image = UIImage(systemName: "square.3.layers.3d.down.left.slash")
        }
        
        titleLabel.text = data.item.symbol
        subTitleLabel.text = data.item.name

        if data.item.data.changePercentage.krw >= 0 {
            statusimageView.image = UIImage(systemName: "arrowtriangle.up.fill")
            statusimageView.tintColor = .customRed
            statusPercentLabel.textColor = .customRed
        } else {
            statusimageView.image = UIImage(systemName: "arrowtriangle.down.fill")
            statusimageView.tintColor = .customBlue
            statusPercentLabel.textColor = .customBlue
        }
        
        statusPercentLabel.text = "\(data.item.data.changePercentage.krw.commonRound())%"
    }
    
}
