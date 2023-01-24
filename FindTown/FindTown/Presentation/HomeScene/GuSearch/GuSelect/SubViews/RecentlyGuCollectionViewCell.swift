//
//  RecentlySearchCollectionViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit

import FindTownUI
import RxSwift
import RxCocoa

protocol RecentlyGuCollectionViewCellDelegate: AnyObject {
    func closeTapped(filter: String)
}

final class RecentlyGuCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: RecentlyGuCollectionViewCellDelegate?
    
    private var disposeBag = DisposeBag()
    
    // MARK: Views
    
    private let searchCategoryBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ei_close"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    // MARK: Functions
    
    private func addView() {
        contentView.addSubview(searchCategoryBtn)
        contentView.addSubview(closeImageView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            searchCategoryBtn.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchCategoryBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchCategoryBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            searchCategoryBtn.trailingAnchor.constraint(equalTo: closeImageView.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            closeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeImageView.leadingAnchor.constraint(equalTo: searchCategoryBtn.trailingAnchor),
            closeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = FindTownColor.grey2.color
        
        searchCategoryBtn.setTitleColor(FindTownColor.grey6.color, for: .normal)
        searchCategoryBtn.titleLabel?.font = FindTownFont.body3.font
        searchCategoryBtn.isUserInteractionEnabled = false
        
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }
    
    func setupCell(_ filter: String, _ row: Int) {
        searchCategoryBtn.setTitle(filter, for: .normal)
    }
    
    @objc private func closeTapped() {
        guard let searchCategoryText = searchCategoryBtn.titleLabel?.text else { return }
        delegate?.closeTapped(filter: searchCategoryText)
    }
}
