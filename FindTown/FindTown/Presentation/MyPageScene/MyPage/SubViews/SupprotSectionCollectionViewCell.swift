//
//  DemoCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownUI

final class SupprotSectionCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var model: MyPageSection.Support?
    
    private let titleLabel = FindTownLabel(text: "", font: .body1)
    private let imageView = UIImageView()
    private let emptyView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView, titleLabel, emptyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: MyPageSection.Support) {
        
        self.model = model
        
        imageView.image = model.image
        
        if model.image == UIImage() {
            imageView.isHidden = true
            titleLabel.font = FindTownFont.body3.font
            titleLabel.textColor = FindTownColor.grey5.color
        }
        
        titleLabel.text = model.title
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(cellTap(sender:)))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc func cellTap(sender: UITapGestureRecognizer) {
        model?.action()
    }
}
