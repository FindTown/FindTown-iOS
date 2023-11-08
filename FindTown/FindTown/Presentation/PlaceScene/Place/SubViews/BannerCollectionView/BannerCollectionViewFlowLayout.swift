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
        minimumInteritemSpacing = itemSpacing
        estimatedItemSize = CGSize(width: 300, height: 80)
    }
}
