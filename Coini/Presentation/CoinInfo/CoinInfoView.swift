//
//  CoinInfoView.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import SnapKit

final class CoinInfoView: BaseView {
    
    let searchBar = UISearchBar()
    
    let keywordView = UIView()
    let keywordTitleLabel = UILabel()
    let keywordDateLabel = UILabel()
    let keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let nftTitleLabel = UILabel()
    let nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        keywordView.addSubViews(
            keywordTitleLabel,
            keywordDateLabel
        )
        
        addSubViews(
            searchBar,
            keywordView,
            keywordCollectionView,
            nftTitleLabel,
            nftCollectionView
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        keywordCollectionView.collectionViewLayout = configureKeywordCollectionViewLayout()
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        keywordView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        keywordTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        keywordDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(26 * 7 + 20 * 6)
        }
        
        nftTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(keywordCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nftTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    override func configureView() {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor : UIColor.customDarkGray.cgColor])
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.layer.borderColor = UIColor.customDarkGray.cgColor
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftView?.tintColor = .customDarkGray
        searchBar.searchTextField.textColor = .customDarkGray
        
        keywordTitleLabel.text = "인기 검색어"
        keywordTitleLabel.font = .boldSystemFont(ofSize: 14)
        keywordTitleLabel.textColor = .customNavy
        
        keywordDateLabel.font = .systemFont(ofSize: 12)
        keywordDateLabel.textColor = .customDarkGray
        
        keywordCollectionView.showsVerticalScrollIndicator = false
        keywordCollectionView.showsHorizontalScrollIndicator = false
        keywordCollectionView.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.identifier)
        
        nftTitleLabel.text = "인기 NFT"
        nftTitleLabel.font = .boldSystemFont(ofSize: 14)
        nftTitleLabel.textColor = .customNavy
        
        nftCollectionView.backgroundColor = .red
    }
    
    private func configureKeywordCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let verticalSpacing: CGFloat = 20
        let horizontalSpacing: CGFloat = 20
        let deviceWidth = frame.width
        let itemSize = (deviceWidth - 40 - horizontalSpacing) / 2
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = verticalSpacing
        layout.minimumLineSpacing = horizontalSpacing
        layout.itemSize = CGSize(width: itemSize, height: 26)
        return layout
    }
    
}
