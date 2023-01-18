//
//  AnonymousView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import FindTownUI

final class AnonymousView: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    let signUpButton = FTButton(style: .mediumFilled)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnonymousView {
    
    func setupLayout() {
        [iconImageView, titleLabel, subLabel, signUpButton].forEach {
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
            signUpButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24.0),
            signUpButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44.0),
            signUpButton.widthAnchor.constraint(equalToConstant: 152.0)
        ])

    }
    
    func setupView() {
        self.backgroundColor = .clear
        
        iconImageView.image = UIImage(named: "anonymousIcon")
        titleLabel.font = FindTownFont.body1.font
        titleLabel.textColor = FindTownColor.grey6.color
        titleLabel.text = "찜 기능은 회원 가입 후 이용 가능해요."
        
        subLabel.font = FindTownFont.body4.font
        subLabel.textColor = FindTownColor.grey5.color
        subLabel.text = "로그인 / 가입 후 편리하게 동네를 찜해보세요!"
        
        signUpButton.setTitle("로그인 / 회원가입하기", for: .normal)
    }

}
