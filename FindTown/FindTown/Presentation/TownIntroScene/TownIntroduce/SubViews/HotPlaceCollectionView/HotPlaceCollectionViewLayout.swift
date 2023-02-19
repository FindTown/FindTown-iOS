//
//  HotPlaceCollectionViewLayout.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit

final class HotPlaceCollectionViewLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 6.0

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
        estimatedItemSize = CGSize(width: 100.0, height: 28.0)
    }
}
