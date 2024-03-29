//
//  File.swift
//  
//
//  Created by 장선영 on 2023/01/02.
//

import UIKit
import FindTownUI

final class MapDetailCategoryView: UIView {
    
    private var detailCategoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStackView(subCategories: [InfraSubCategory]) {
        detailCategoryStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for subCategory in subCategories {
            let view = MapDetailComponentView()
            view.textLabel.text = subCategory.description
            view.colorView.backgroundColor = subCategory.iconColor
            detailCategoryStackView.addArrangedSubview(view)
         }
     }
}

private extension MapDetailCategoryView {
    
    func setupView() {
        self.backgroundColor = FindTownColor.white.color.withAlphaComponent(0.8)
        self.layer.cornerRadius = 8
    }
    
    func setupLayout() {
        self.addSubview(detailCategoryStackView)
        detailCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailCategoryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            detailCategoryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            detailCategoryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            detailCategoryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0)
        ])
    }
}
