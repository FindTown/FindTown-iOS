//
//  MyPageCollectionView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

final class MyPageCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: MyPageCollectionViewCompositionalLayout().setupView())
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
        
        register(SupportSectionCollectionViewCell.self,
                 forCellWithReuseIdentifier: SupportSectionCollectionViewCell.reuseIdentifier)
        register(InfoSectionCollectionViewCell.self,
                 forCellWithReuseIdentifier: InfoSectionCollectionViewCell.reuseIdentifier)
        register(DividerView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: DividerView.reuseIdentifier)
        register(CollectionHeaderView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
    }
}
