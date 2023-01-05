//
//  MapCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/05.
//

import UIKit
import FindTownUI

class MapCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MapCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = FindTownColor.grey5.color
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FindTownFont.body4.font
        label.textColor = FindTownColor.grey6.color
        return label
    }()
    
    func setupCell(image: UIImage, title: String) {
        self.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        setupView()
        setupLayout()
        imageView.image = image
        imageView.tintColor = FindTownColor.grey5.color
        titleLabel.text = title
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
}

private extension MapCollectionViewCell {
    
    func setupView() {
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.borderColor = FindTownColor.grey2.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        nonSelectedView()
    }
    
    func setupLayout() {
        [imageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16.0),
            imageView.heightAnchor.constraint(equalToConstant: 16.0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func selectedView() {
        contentView.layer.borderColor = FindTownColor.primary.color.cgColor
        imageView.tintColor = FindTownColor.primary.color
        titleLabel.textColor = FindTownColor.primary.color
    }
    
    func nonSelectedView() {
        contentView.layer.borderColor = FindTownColor.grey2.color.cgColor
        imageView.tintColor = FindTownColor.grey5.color
        titleLabel.textColor = FindTownColor.grey6.color
    }
}
