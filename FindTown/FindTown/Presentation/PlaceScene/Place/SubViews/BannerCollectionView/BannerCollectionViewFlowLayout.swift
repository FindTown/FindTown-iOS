//
//  BannerCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import UIKit

final class BannerCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 16.0

    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        scrollDirection = .horizontal
        minimumLineSpacing = itemSpacing
        let width = self.collectionView?.bounds.width ?? 300
        sectionInset = UIEdgeInsets(top: 0.0,
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 16.0)
        estimatedItemSize = CGSize(width: width, height: 80)
    }
}
