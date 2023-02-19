//
//  TownMoodCollectionViewLayout.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit

final class TownMoodCollectionViewLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 8.0

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
        estimatedItemSize = CGSize(width: 120.0, height: 32.0)
    }
}
