//
//  StoreCollectionViewFlowLayout.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit

final class StoreCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        itemSize = CGSize(width: 290, height: 155)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = max(currentPage - 1, 0)
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = min(currentPage + 1, itemsCount - 1)
        }
        
        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage)
        previousOffset = updatedOffset
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}
