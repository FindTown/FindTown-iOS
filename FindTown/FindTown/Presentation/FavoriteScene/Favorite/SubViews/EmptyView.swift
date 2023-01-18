//
//  isEmptyView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import FindTownUI

final class EmptyView: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = FindTownLabel(text: "찜한 동네가 아직 없어요.",
                                           font: .body1,
                                           textColor: .grey6,
                                           textAlignment: .center)
    private let subLabel = FindTownLabel(text: "나에게 맞는 동네를 찾아서 찜해보세요!",
                                         font: .body4,
                                         textColor: .grey5,
                                         textAlignment: .center)
    let findOutButton = FTButton(style: .mediumFilled)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        iconImageView.image = UIImage(named: "emptyIcon")
        titleLabel.setLineHeight(lineHeight: 24.0)
        subLabel.setLineHeight(lineHeight: 20.0)
        findOutButton.setTitle("나에게 맞는 동네 찾기", for: .normal)
    }
}
