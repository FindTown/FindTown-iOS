//
//  StoreCollectionView.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

class StoreCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: StoreCollectionViewFlowLayout())
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
        isPagingEnabled = false
        decelerationRate = .fast
        register(MapStoreCollectionViewCell.self,
                 forCellWithReuseIdentifier: MapStoreCollectionViewCell.reuseIdentifier)
    }
}
