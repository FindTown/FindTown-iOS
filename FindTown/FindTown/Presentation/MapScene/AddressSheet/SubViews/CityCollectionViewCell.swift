//
//  CityCollectionViewCell.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import UIKit
import FindTownUI

import RxSwift

class CityCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var disposeBag = DisposeBag()
    
    private let nameLabel = FindTownLabel(
                            text: "",
                            font: .body3,
                            textColor: .grey4)
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedView()
            } else {
                nonSelectedView()
            }
        }
    }
    
    func setupCell(itemText: String) {
        nameLabel.text = itemText
    }
}

private extension CityCollectionViewCell {
    
    func setupView() {
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = FindTownColor.grey4.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        [nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func selectedView() {
        contentView.layer.borderColor = FindTownColor.primary.color.cgColor
        nameLabel.textColor = FindTownColor.primary.color
    }
    
    func nonSelectedView() {
        contentView.layer.borderColor = FindTownColor.grey4.color.cgColor
        nameLabel.textColor = FindTownColor.grey4.color
    }
}
