//
//  TownTableViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import UIKit

import FindTownUI

final class TownTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Views
    
    private let townIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle.fill")
        return imageView
    }()
    
    private let townTitle = FindTownLabel(text: "", font: .subtitle4)
    private let townIntroduceTitle = FindTownLabel(text: "", font: .body3, textColor: .grey5)
    
    private let heartIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.setImage(UIImage(named: "favorite_selected"), for: .selected)
        return button
    }()
    
    private let btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let introduceBtn = FTButton(style: .mediumFilled)
    private let mapBtn = FTButton(style: .mediumTintedWithRadius)
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        )
    }
    
    // MARK: Functions
    
    private func addView() {
        self.backgroundColor = FindTownColor.back2.color
        [introduceBtn, mapBtn].forEach {
            btnStackView.addArrangedSubview($0)
        }
        [townIcon, townTitle, townIntroduceTitle, heartIcon, btnStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            townIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            townIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            townIcon.widthAnchor.constraint(equalToConstant: 40),
            townIcon.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            townTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            townTitle.leadingAnchor.constraint(equalTo: townIcon.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            townIntroduceTitle.topAnchor.constraint(equalTo: townTitle.bottomAnchor, constant: 5),
            townIntroduceTitle.leadingAnchor.constraint(equalTo: townIcon.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            heartIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            heartIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            heartIcon.widthAnchor.constraint(equalToConstant: 25),
            heartIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            btnStackView.topAnchor.constraint(equalTo: townIntroduceTitle.bottomAnchor, constant: 20),
            btnStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            btnStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            btnStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupView() {
        mapBtn.changesSelectionAsPrimaryAction = false
        mapBtn.isSelected = true
        
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.addCustomShadow(shadowX: 0, shadowY: 2,
                                          shadowColor: FindTownColor.black.color.withAlphaComponent(0.4),
                                          blur: 10.0, spread: 0, alpha: 0.4)
        
    }
    
    func setupCell(_ model: Any) {
        guard let model = model as? townModelTest else { return }
        townTitle.text = model.dong
        townIntroduceTitle.text = model.introduce
        
        introduceBtn.setTitle("동네 소개", for: .normal)
        mapBtn.setTitle("동네 지도", for: .normal)
    }
}
