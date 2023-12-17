//
//  isEmptyView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import FindTownUI

/// 찜한 동네가 없는 경우의 View
final class EmptyView: UIView {
    
    private let iconImageView = UIImageView()
    private lazy var titleLabel = FindTownLabel(text: type.title,
                                           font: .body1,
                                           textColor: .grey6,
                                           textAlignment: .center)
    private lazy var subLabel = FindTownLabel(text: type.subTitle,
                                         font: .body4,
                                         textColor: .grey5,
                                         textAlignment: .center)
    let findOutButton = FTButton(style: .mediumFilled)
    
    let type: EmptyType
    
    init(type: EmptyType) {
        self.type = type
        super.init(frame: .zero)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyView {
    
    func setupLayout() {
        [iconImageView, titleLabel, subLabel, findOutButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            subLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -2.0),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12.0),
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            findOutButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24.0),
            findOutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            findOutButton.heightAnchor.constraint(equalToConstant: 44.0),
            findOutButton.widthAnchor.constraint(equalToConstant: 152.0)
        ])
    }
    
    func setupView() {
        self.backgroundColor = .clear
        
        iconImageView.image = type.iconImage
        titleLabel.setLineHeight(lineHeight: 24.0)
        subLabel.setLineHeight(lineHeight: 20.0)
        subLabel.numberOfLines = 2
        findOutButton.setTitle("나에게 맞는 동네 찾기", for: .normal)
        findOutButton.isHidden = type.isButtonHidden
    }
}
