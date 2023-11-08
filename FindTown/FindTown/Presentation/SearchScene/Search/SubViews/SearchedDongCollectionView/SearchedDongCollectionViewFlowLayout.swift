//
//  SearchedDongCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/04.
//

import UIKit

final class SearchedDongCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 10.0

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
        estimatedItemSize = CGSize(width: 77, height: 36)
    }
}
