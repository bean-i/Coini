//
//  SearchView.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    let backButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    let searchTextField = UITextField()
    
    let headerTabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let pageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTabCollectionView.collectionViewLayout = configureHeaderTabCollectionViewLayout()
        pageCollectionView.collectionViewLayout = configurePageCollectionViewLayout()
    }
    
    override func configureHierarchy() {
        addSubViews(
            headerTabCollectionView,
            pageCollectionView
        )
    }
    
    override func configureLayout() {
        headerTabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        pageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerTabCollectionView.snp.bottom)
//            make.horizontalEdges.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        backButton.tintColor = .customNavy
        
        searchTextField.text = "Bitcoin"
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .green
        searchTextField.textAlignment = .left
        
        headerTabCollectionView.backgroundColor = .clear
        headerTabCollectionView.showsHorizontalScrollIndicator = false
        headerTabCollectionView.showsVerticalScrollIndicator = false
        headerTabCollectionView.register(HeaderTabCollectionViewCell.self, forCellWithReuseIdentifier: HeaderTabCollectionViewCell.identifier)
        
        pageCollectionView.backgroundColor = .white
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.showsVerticalScrollIndicator = false
        pageCollectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.identifier)
        pageCollectionView.isPagingEnabled = true
    }
    
    private func configureHeaderTabCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = frame.width
        let itemSize = deviceWidth / 3
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemSize, height: 44)
        return layout
    }
    
    private func configurePageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = frame.width
        let itemHeight = frame.height - 220 // 디바이스 전체 높이에서  - 44 - 네비게이션바 - 탭바
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return layout
    }
}
