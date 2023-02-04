//
//  MapStoreCollectionViewCell.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/07.
//

import UIKit
import FindTownUI

import RxSwift

protocol MapStoreCollectionViewCellDelegate: AnyObject {
    func didTapInformationUpdateButton()
    func didTapCopyButton(text: String)
}

final class MapStoreCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
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
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 6
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
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let copyButton: FTButton = {
        let button = FTButton(style: .copy)
        button.setSelectedImage(normalImage: UIImage(named: "copy"), selectedImage: UIImage(named: "copy"))
        button.setTitle("복사", for: .normal)
        return button
    }()
    
    private let addressEmptyView: UIView = {
        let view = UIView()
        return view
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
    
    weak var delegate: MapStoreCollectionViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        
        let copyTap = UITapGestureRecognizer(target: self, action: #selector(copyAction))
        copyButton.addGestureRecognizer(copyTap)
        let updateTap = UITapGestureRecognizer(target: self, action: #selector(updateAction))
        informationUpdateButton.addGestureRecognizer(updateTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(store: Store) {
        typeImageView.image = store.thema.storeDetailType.image
        typeNameLabel.text = store.thema.storeDetailType.description
        nameLabel.text = store.name
        addressLabel.text = store.address
    }
    
    @objc func copyAction() {
        guard let addressText = self.addressLabel.text else { return }
        self.delegate?.didTapCopyButton(text: addressText)
    }
    
    @objc func updateAction() {
        self.delegate?.didTapInformationUpdateButton()
    }
}

private extension MapStoreCollectionViewCell {
    
    func setupView() {
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.borderColor = FindTownColor.grey2.color.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowColor = FindTownColor.grey4.color.cgColor
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [typeStackView, titleStackView, bottomStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerStackView.addArrangedSubview($0)
        }
        
        [typeImageView, typeNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            typeStackView.addArrangedSubview($0)
        }
        
        [nameLabel, contentStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleStackView.addArrangedSubview($0)
        }
        
        [addressLabel, copyButton, addressEmptyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.addArrangedSubview($0)
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
            
            typeImageView.widthAnchor.constraint(equalToConstant: 24.0),
            typeImageView.heightAnchor.constraint(equalToConstant: 24.0),
            nameLabel.heightAnchor.constraint(equalToConstant: 24.0),
            
            titleStackView.topAnchor.constraint(equalTo: typeImageView.bottomAnchor, constant: 4),
            
            contentStackView.widthAnchor.constraint(equalToConstant: 258.0),
            contentStackView.heightAnchor.constraint(equalToConstant: 41.0),
            
            copyButton.widthAnchor.constraint(equalToConstant: 45),
            copyButton.heightAnchor.constraint(equalToConstant: 18),
            
            informationUpdateButton.widthAnchor.constraint(equalToConstant: 78),
            informationUpdateButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addressLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
