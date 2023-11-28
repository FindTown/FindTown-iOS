//
//  BannerCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import UIKit

import FindTownUI

import SnapKit

final class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "banner1")
        return imageView
    }()
    
    func setupCell(image: UIImage) {
        imageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BannerCollectionViewCell {
    func setupView() {
        contentView.layer.cornerRadius = 16
    }
    
    func setupLayout() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
  
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
