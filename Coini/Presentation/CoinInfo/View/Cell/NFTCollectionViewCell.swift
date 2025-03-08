//
//  NFTCollectionViewCell.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import SnapKit
import Kingfisher

final class NFTCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "NFTCollectionViewCell"
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let statusView = UIStackView()
    let statusImageView = UIImageView()
    let statusPercentLabel = UILabel()
    
    override func configureHierarchy() {
        statusView.addArrangedSubviews(
            statusImageView,
            statusPercentLabel
        )
        contentView.addSubViews(
            imageView,
            titleLabel,
            subTitleLabel,
            statusView
        )
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(72)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        statusImageView.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        
        titleLabel.font = .boldSystemFont(ofSize: 9)
        titleLabel.textColor = .customNavy
        titleLabel.textAlignment = .center
        
        subTitleLabel.font = .systemFont(ofSize: 9, weight: .regular)
        subTitleLabel.textColor = .customDarkGray
        subTitleLabel.textAlignment = .center
        
        statusView.axis = .horizontal
        statusView.spacing = 3
        statusView.alignment = .center
        
        statusPercentLabel.font = .boldSystemFont(ofSize: 9)
    }
    
    func configureData(data: SearchNFT) {
        // 이미지
        if let url = URL(string: data.thumb) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "arrowshape.down"))
        } else {
            imageView.image = UIImage(systemName: "square.3.layers.3d.down.left.slash")
        }
        
        titleLabel.text = data.name
        subTitleLabel.text = data.data.floorPrice
        
        statusImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        statusImageView.tintColor = .customNavy
        
        // 변동폭
        if let doublePercent = Double(data.data.floorPercentage) {
            if doublePercent >= 0 {
                statusImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
                statusImageView.tintColor = .customRed
                statusPercentLabel.text = "\(doublePercent.commonRound())%"
                statusPercentLabel.textColor = .customRed
            } else {
                statusImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
                statusImageView.tintColor = .customBlue
                statusPercentLabel.text = "\((-doublePercent).commonRound())%"
                statusPercentLabel.textColor = .customBlue
            }
        } else {
            statusPercentLabel.text = "0.00%"
        }
    }
    
}
