//
//  CategoryCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

final class CategoryCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        scrollDirection = .horizontal
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 0.0,
                                    left: 17.0,
                                    bottom: 0.0,
                                    right: 82.0)
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
