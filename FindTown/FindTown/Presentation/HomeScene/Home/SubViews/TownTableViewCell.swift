//
//  TownTableViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import UIKit

import FindTownUI
import RxCocoa
import RxSwift

protocol TownTableViewCellDelegate: AnyObject {
    func didTapGoToMapButton()
    func didTapGoToIntroduceButton()
    func didTapFavoriteButton()
}

final class TownTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: TownTableViewCellDelegate?
    
    var townTableModel: TownTableModel?
    
    var disposeBag = DisposeBag()
    
    // MARK: Views
    
    private let townIconView = UIView()
    private let townIconImageView = UIImageView()
    private let townTitle = FindTownLabel(text: "", font: .subtitle4)
    private let townIntroduceTitle = FindTownLabel(text: "", font: .body3, textColor: .grey5)
    
    private let favoriteIcon: UIButton = {
        let button = UIButton()
        button.changesSelectionAsPrimaryAction = true
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.setImage(UIImage(named: "favorite_selected"), for: .selected)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 7
        return stackView
    }()
    
    private let introduceButton = FTButton(style: .mediumFilled)
    private let mapButton = FTButton(style: .mediumTintedWithRadius)
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setLayout()
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8,
                                                                     left: 16,
                                                                     bottom: 8,
                                                                     right: 16))
    }
    
    // MARK: Functions
    
    private func addView() {
        [introduceButton, mapButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [townIconView, townTitle, townIntroduceTitle, favoriteIcon, buttonStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        townIconView.addSubview(townIconImageView)
        townIconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            townIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            townIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            townIconView.widthAnchor.constraint(equalToConstant: 48),
            townIconView.heightAnchor.constraint(equalToConstant: 48),
            townIconImageView.centerXAnchor.constraint(equalTo: townIconView.centerXAnchor),
            townIconImageView.centerYAnchor.constraint(equalTo: townIconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            townTitle.topAnchor.constraint(equalTo: townIconView.topAnchor),
            townTitle.leadingAnchor.constraint(equalTo: townIconView.trailingAnchor, constant: 16),
            townIntroduceTitle.topAnchor.constraint(equalTo: townTitle.bottomAnchor, constant: 4),
            townIntroduceTitle.leadingAnchor.constraint(equalTo: townTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 24),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: townIntroduceTitle.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupView() {
        self.backgroundColor = FindTownColor.back2.color
        
        townIconView.backgroundColor = FindTownColor.white.color
        townIconView.layer.cornerRadius = 24
        townIconView.layer.borderWidth = 1.0
        townIconView.layer.borderColor = FindTownColor.grey3.color.cgColor
        townIconImageView.image = UIImage(named: "hospital")
        
        mapButton.changesSelectionAsPrimaryAction = false
        mapButton.isSelected = true
        mapButton.setTitle("동네 지도", for: .normal)
        
        introduceButton.setTitle("동네 소개", for: .normal)
        
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.addCustomShadow(shadowX: 0, shadowY: 2,
                                          shadowColor: FindTownColor.black.color.withAlphaComponent(0.4),
                                          blur: 10.0, spread: 0, alpha: 0.4)
        
        selectionStyle = .none
        
        introduceButton.addTarget(self, action: #selector(didTapGoToIntroduceButton), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(didTapGoToMapButton), for: .touchUpInside)
    }
    
    private func bind() {
        favoriteIcon.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.didTapFavoriteButton()
            }
            .disposed(by: disposeBag)
    }
    
    func setupCell(_ model: Any) {
        guard let model = model as? TownTableModel else { return }
        townTableModel = model
        
        townTitle.text = model.county
        townIntroduceTitle.text = model.townIntroduction
        townIconImageView.image = model.countyIcon
    }
}

private extension TownTableViewCell {
    @objc func didTapGoToMapButton() {
        self.delegate?.didTapGoToMapButton()
    }
    
    @objc func didTapGoToIntroduceButton() {
        self.delegate?.didTapGoToIntroduceButton()
    }
    
    func didTapFavoriteButton() {
        self.delegate?.didTapFavoriteButton()
    }
}
