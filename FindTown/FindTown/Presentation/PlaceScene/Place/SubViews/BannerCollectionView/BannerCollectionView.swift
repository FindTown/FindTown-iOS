//
//  BannerCollectionView.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import UIKit

final class BannerCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: BannerCollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = false
        self.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier)
    }

}
