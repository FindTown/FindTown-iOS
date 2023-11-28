//
//  ThemeCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/27.
//

import UIKit

final class ThemeCollectionViewFlowLayout: UICollectionViewFlowLayout {

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
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 82.0)
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
