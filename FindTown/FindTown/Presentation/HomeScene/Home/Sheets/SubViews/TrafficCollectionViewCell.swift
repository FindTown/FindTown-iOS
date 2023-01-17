//
//  TrafficCollectionViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit
import FindTownUI

import RxSwift

final class TrafficCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    
    private let nameButton = FTButton(style: .small)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override var isSelected: Bool {
        didSet {
            nameButton.isSelected = isSelected
        }
    }
    
    // MARK: - Functions
    
    private func addView() {
        [nameButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            nameButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            nameButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
        
        let screenWidth = UIScreen.main.bounds.width
        let itemSizeWidth = screenWidth * 0.200
        let itemSizeHeight = screenWidth * 0.112
        NSLayoutConstraint.activate([
            nameButton.widthAnchor.constraint(equalToConstant: itemSizeWidth),
            nameButton.heightAnchor.constraint(equalToConstant: itemSizeHeight),
        ])
    }
    
    func setupCell(itemText: String) {
        nameButton.setTitle(itemText, for: .normal)
        nameButton.isUserInteractionEnabled = false
    }
}
