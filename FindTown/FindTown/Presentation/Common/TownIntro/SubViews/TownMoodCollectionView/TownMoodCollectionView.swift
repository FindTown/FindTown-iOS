//
//  TownMoodCollectionView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit

final class TownMoodCollectionView: UICollectionView {
        
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: TownMoodCollectionViewLayout())
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
        register(TownMoodCollectionViewCell.self,
                 forCellWithReuseIdentifier: TownMoodCollectionViewCell.reuseIdentifier)
    }
}
