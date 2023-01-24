//
//  RecentlySearchCollectionView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit

final class RecentlyGuCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: RecentlyGuCollectionViewFlowLayout())
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
        register(RecentlyGuCollectionViewCell.self,
                 forCellWithReuseIdentifier: RecentlyGuCollectionViewCell.reuseIdentifier)
    }
}
