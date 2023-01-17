//
//  CategoryCollectionViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import UIKit

import FindTownUI
import RxSwift

final class FillterCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var disposeBag = DisposeBag()
    
    // MARK: Views
    
    private let searchCategoryBtn = FTButton(style: .buttonFilter)
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(searchCategoryBtn)
        
        searchCategoryBtn.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            searchCategoryBtn.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchCategoryBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchCategoryBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchCategoryBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    // MARK: Functions

    func setupCell(_ model: Any, _ row: Int) {
        searchCategoryBtn.configuration?.contentInsets.leading = 12
        searchCategoryBtn.configuration?.contentInsets.trailing = 12
        searchCategoryBtn.setTitleColor(FindTownColor.black.color, for: .normal)
        searchCategoryBtn.setTitle(String(describing: model), for: .normal)
        searchCategoryBtn.setSelectedImage(normalImage: UIImage(named: "arrowDown") ?? UIImage(),
                                           selectedImage: UIImage(named: "arrowDown_selected") ?? UIImage())
    }
}
