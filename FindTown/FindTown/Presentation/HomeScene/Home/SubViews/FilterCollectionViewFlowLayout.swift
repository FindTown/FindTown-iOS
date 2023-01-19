//
//  FilterCollectionFlowLayout.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/17.
//

import UIKit

final class FilterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        scrollDirection = .horizontal
    }
}
