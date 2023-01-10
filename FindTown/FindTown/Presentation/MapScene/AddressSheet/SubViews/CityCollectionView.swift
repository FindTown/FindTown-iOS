//
//  CityCollectionView.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

class CityCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: CityCollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = false
        self.register(
            CityCollectionViewCell.self,
            forCellWithReuseIdentifier: CityCollectionViewCell.reuseIdentifier)
    }

}
