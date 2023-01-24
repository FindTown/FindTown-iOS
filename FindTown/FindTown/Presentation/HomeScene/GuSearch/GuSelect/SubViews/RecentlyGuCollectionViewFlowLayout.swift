//
//  RecentlySearchCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit

final class RecentlyGuCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        scrollDirection = .horizontal
    }
}
