//
//  SearchedDongCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/04.
//

import UIKit

import FindTownUI

import SnapKit

protocol SearchedDongCollectionViewCellDelegate {
    func deletedDongData(data: Search)
}

final class SearchedDongCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
        
    var delegate: SearchedDongCollectionViewCellDelegate?
    var data: Search?
    
    // MARK: View
    
    private let titleLabel = FindTownLabel(text: "신림동", font: .body3, textColor: .grey6)
    private let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ data: Search) {
        self.data = data
        titleLabel.text = data.data
    }
}

extension SearchedDongCollectionViewCell {
    
    func setupView() {
        self.backgroundColor = FindTownColor.grey2.color
        self.layer.cornerRadius = 8
        closeButton.setImage(UIImage(named: "ei_close"), for: .normal)
        closeButton.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(10)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
    }
    
    func addView() {
        [titleLabel, closeButton].forEach {
            self.addSubview($0)
        }
    }
}

extension SearchedDongCollectionViewCell {
    @objc
    func didTapCloseButton() {
        print("didTapCloseButton")
        guard let data = self.data else { return }
        print("data: \(data)")
        self.delegate?.deletedDongData(data: data)
    }
}
