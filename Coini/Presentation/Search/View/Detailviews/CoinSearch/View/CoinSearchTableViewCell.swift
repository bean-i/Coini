//
//  CoinSearchTableViewCell.swift
//  Coini
//
//  Created by 이빈 on 3/9/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class CoinSearchTableViewCell: BaseTableViewCell {
    
    static let identifier = "CoinSearchTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let coinImageView = UIImageView()
    
    let infoStackView = UIStackView()
    
    let topView = UIView()
    let titleLabel = UILabel()
    let rankStackView = UIStackView()
    let leftview = UIView()
    let rankLabel = UILabel()
    let rightView = UIView()
    
    let subTitleLabel = UILabel()
    
    let starButton = StarButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        rankStackView.addArrangedSubviews(
            leftview,
            rankLabel,
            rightView
        )
        
        topView.addSubViews(
            titleLabel,
            rankStackView
        )
        
        infoStackView.addArrangedSubviews(
            topView,
            subTitleLabel
        )
        
        contentView.addSubViews(
            coinImageView,
            infoStackView,
            starButton
        )
    }
    
    override func configureLayout() {
        coinImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(36)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
               
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        rankStackView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        
        leftview.snp.makeConstraints { make in
            make.width.equalTo(5)
        }
        
        rightView.snp.makeConstraints { make in
            make.width.equalTo(5)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        coinImageView.tintColor = .black
        coinImageView.clipsToBounds = true
        coinImageView.layer.cornerRadius = 18
        coinImageView.contentMode = .scaleAspectFill
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 3
        
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = .customNavy
        
        subTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subTitleLabel.textColor = .customDarkGray
        
        rankStackView.axis = .horizontal
        rankStackView.layer.cornerRadius = 3
        rankStackView.backgroundColor = .customLightGray
        
        rankLabel.font = .boldSystemFont(ofSize: 9)
        rankLabel.textColor = .customDarkGray
    }
    
    func configureData(data: DetailCoin) {
        starButton.id = data.id
        
        // 이미지
        if let url = URL(string: data.thumb) {
            coinImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "arrowshape.down"))
        } else {
            coinImageView.image = UIImage(systemName: "square.3.layers.3d.down.left.slash")
        }
        
        titleLabel.text = data.symbol
        subTitleLabel.text = data.name
        rankLabel.text = "#\(data.rank)"
    }
    
}
