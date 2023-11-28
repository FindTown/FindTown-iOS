//
//  ThemeCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/28.
//

import UIKit
import FindTownUI

import RxSwift
import SnapKit

final class ThemeCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = FindTownColor.grey5.color
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FindTownFont.body4.font
        label.textColor = FindTownColor.grey6.color
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        nonSelectedView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(title: String) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10,
                                                                     left: 0,
                                                                     bottom: 15,
                                                                     right: 0))
    }
}

private extension ThemeCollectionViewCell {
    
    func setupView() {
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.borderColor = FindTownColor.grey2.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        nonSelectedView()
    }
    
    func setupLayout() {
        
        [stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [titleLabel].forEach {
            self.stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 57),
            
            imageView.widthAnchor.constraint(equalToConstant: 16.0),
            imageView.heightAnchor.constraint(equalToConstant: 16.0),
        ])
    }
}

private extension ThemeCollectionViewCell {
    func selectedView() {
        contentView.backgroundColor = FindTownColor.grey7.color
        contentView.layer.borderColor = FindTownColor.grey7.color.cgColor
        titleLabel.textColor = FindTownColor.white.color
    }
    
    func nonSelectedView() {
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.borderColor = FindTownColor.grey4.color.cgColor
        titleLabel.textColor = FindTownColor.grey6.color
    }
}
