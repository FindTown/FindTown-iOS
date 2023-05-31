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
    func didTapGoToMapButton(cityCode: Int)
    func didTapGoToIntroduceButton(cityCode: Int)
    func didTapFavoriteButton(cityCode: Int)
}

final class TownTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: TownTableViewCellDelegate?
    
    var townTableModel: TownTableModel?
    
    var disposeBag = DisposeBag()
    
    var cityCode: Int?
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        disposeBag = DisposeBag()
    }
    
    // MARK: Views
    
    private let townTitle = FindTownLabel(text: "", font: .subtitle2)
    private let townIntroduceTitle = FindTownLabel(text: "", font: .label2, textColor: .grey5)
    private let townMoodCollectionView = TownMoodCollectionView()
    
    private let favoriteIcon: UIButton = {
        let button = UIButton()
        if !UserDefaultsSetting.isAnonymous {
            button.changesSelectionAsPrimaryAction = true
        }
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
        
        [townMoodCollectionView, townTitle, townIntroduceTitle, favoriteIcon, buttonStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            townMoodCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            townMoodCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            townMoodCollectionView.trailingAnchor.constraint(equalTo: favoriteIcon.leadingAnchor, constant: -16),
            townMoodCollectionView.heightAnchor.constraint(equalToConstant: 35.0)
        ])
        
        NSLayoutConstraint.activate([
            townTitle.topAnchor.constraint(equalTo: townMoodCollectionView.bottomAnchor, constant: 16),
            townTitle.leadingAnchor.constraint(equalTo: townMoodCollectionView.leadingAnchor),
            townIntroduceTitle.centerYAnchor.constraint(equalTo: townTitle.centerYAnchor),
            townIntroduceTitle.leadingAnchor.constraint(equalTo: townTitle.trailingAnchor, constant: 8.0)
        ])
        
        NSLayoutConstraint.activate([
            favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 24),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: townTitle.bottomAnchor, constant: 22),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupView() {
        self.backgroundColor = FindTownColor.back2.color
        self.selectionStyle = .none
        
        mapButton.changesSelectionAsPrimaryAction = false
        mapButton.isSelected = true
        mapButton.setTitle("동네 지도", for: .normal)
        
        introduceButton.setTitle("동네 소개", for: .normal)
        
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.addCustomShadow(shadowX: 0, shadowY: 2,
                                          shadowColor: FindTownColor.black.color.withAlphaComponent(0.4),
                                          blur: 10.0, spread: 0, alpha: 0.4)
    
        
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
        
        // TODO: API 수정되면 수정 필요
        BehaviorSubject<[TownMood]>(value: [.infra1, .mood4])
            .bind(to: townMoodCollectionView.rx.items(cellIdentifier: TownMoodCollectionViewCell.reuseIdentifier, cellType: TownMoodCollectionViewCell.self)) { index, item, cell in
                cell.setupCell(item)
            }
            .disposed(by: disposeBag)
    }
    
    func setupCell(_ model: Any, cityCode: Int) {
        guard let model = model as? TownTableModel else { return }
        townTableModel = model
        self.cityCode = cityCode
        
        favoriteIcon.isSelected = model.wishTown ? true : false
        townTitle.text = model.county
        townIntroduceTitle.text = model.townIntroduction
        favoriteIcon.isSelected = model.wishTown ? true : false
    }
}

private extension TownTableViewCell {
    @objc func didTapGoToMapButton() {
        guard let cityCode = cityCode else { return }
        self.delegate?.didTapGoToMapButton(cityCode: cityCode)
    }
    
    @objc func didTapGoToIntroduceButton() {
        guard let cityCode = cityCode else { return }
        self.delegate?.didTapGoToIntroduceButton(cityCode: cityCode)
    }
    
    func didTapFavoriteButton() {
        guard let cityCode = cityCode else { return }
        self.delegate?.didTapFavoriteButton(cityCode: cityCode)
    }
}
