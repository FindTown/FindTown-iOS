//
//  DividerView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import FindTownUI

// 섹션 별 divier
final class DividerView: UICollectionReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let dividerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dividerView)
        
        dividerView.backgroundColor = FindTownColor.grey1.color

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: super.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: super.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
