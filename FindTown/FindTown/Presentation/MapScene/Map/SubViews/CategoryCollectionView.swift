//
//  CategoryCollectionView.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

class CategoryCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: CategoryCollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = false
        register(MapCategoryCollectionViewCell.self,
                 forCellWithReuseIdentifier: MapCategoryCollectionViewCell.reuseIdentifier)
    }

}
