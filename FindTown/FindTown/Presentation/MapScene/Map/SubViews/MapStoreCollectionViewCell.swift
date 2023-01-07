//
//  MapStoreCollectionViewCell.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/07.
//

import UIKit
import FindTownUI

import RxSwift

class MapStoreCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MapStoreCollectionViewCell"
    
    var disposeBag = DisposeBag()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        return stackView
    }()
    
    private let typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5.5
        return stackView
    }()
    
    private let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = FindTownColor.grey6.color
        return imageView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    private let typeNameLabel = FindTownLabel(
                            text: "",
                            font: .body4,
                            textColor: .grey6)
    
    private let nameLabel = FindTownLabel(
                            text: "",
                            font: .body1,
                            textColor: .black)
    
    private let addressLabel: FindTownLabel = {
        let label = FindTownLabel(text: "",
                                  font: .label1,
                                  textColor: .grey5)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .trailing
        return stackView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let informationUpdateButton: UIButton = {
        let button = UIButton()
        button.setTitle("정보 수정 요청", for: .normal)
        button.titleLabel?.font = FindTownFont.label2.font
        button.setTitleColor(FindTownColor.grey5.color, for: .normal)
        button.backgroundColor = FindTownColor.grey2.color
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(store: Store) {
        typeImageView.image = UIImage(named: "martIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        typeNameLabel.text = store.thema.storeDetailType.description
        nameLabel.text = store.name
        addressLabel.text = store.address
    }
}

private extension MapStoreCollectionViewCell {
    
    func setupView() {
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.borderColor = FindTownColor.grey2.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [typeStackView, titleStackView, bottomStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerStackView.addArrangedSubview($0)
        }
        
        [nameLabel, addressLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleStackView.addArrangedSubview($0)
        }
        
        [typeImageView, typeNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            typeStackView.addArrangedSubview($0)
        }
        
        [emptyView, informationUpdateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            containerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            containerStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            typeImageView.widthAnchor.constraint(equalToConstant: 15.0),
            typeImageView.heightAnchor.constraint(equalToConstant: 15.0),
            nameLabel.heightAnchor.constraint(equalToConstant: 24.0),
            
            informationUpdateButton.widthAnchor.constraint(equalToConstant: 78),
            informationUpdateButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
