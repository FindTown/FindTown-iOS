//
//  CategoryCollectionView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import UIKit

final class FilterCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: FilterCollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = false
        register(FillterCollectionViewCell.self,
                 forCellWithReuseIdentifier: FillterCollectionViewCell.reuseIdentifier)
    }
}
