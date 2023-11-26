//
//  EmptyDataView.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/18.
//

import UIKit

import FindTownUI

import SnapKit

final class EmptyDataView: UIView {
    let imageView = UIImageView()
    let titleLabel = FindTownLabel(text: "검색 결과가 없습니다.", font: .body1, textColor: .grey6)
    let subtitleLabel = FindTownLabel(text: "검색어의 철자가 정확한지 확인해주세요.", font: .body4, textColor: .grey5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "exclamation")
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyDataView {
    func addView()  {
        [imageView, titleLabel, subtitleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(84)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}
