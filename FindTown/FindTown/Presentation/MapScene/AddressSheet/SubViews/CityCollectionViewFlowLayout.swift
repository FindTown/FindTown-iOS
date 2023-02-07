//
//  CityCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

final class CityCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        let screenWidth = UIScreen.main.bounds.width
        let itemSizeWidth = screenWidth * 0.282
        let itemSizeHeight = screenWidth * 0.112
        let itemSpacing = screenWidth * 0.022
        let lineSpacing = screenWidth * 0.022
        
        self.scrollDirection = .vertical
        self.minimumLineSpacing = lineSpacing
        self.minimumInteritemSpacing = itemSpacing
        self.sectionInset = .zero
        self.itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)
        self.estimatedItemSize = .zero
    }
}
