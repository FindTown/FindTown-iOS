//
//  StoreCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

final class StoreCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        sectionInset = UIEdgeInsets(top: 0.0,
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 16.0)
        itemSize = CGSize(width: 306, height: 165)
    }
    
}
