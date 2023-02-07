//
//  TrafficCollectionView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit

import RxSwift
import RxCocoa

final class TrafficCollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: TrafficCollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.allowsMultipleSelection = true
        self.register(
            TrafficCollectionViewCell.self,
            forCellWithReuseIdentifier: TrafficCollectionViewCell.reuseIdentifier)
    }
}
