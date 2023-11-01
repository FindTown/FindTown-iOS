//
//  EmptyDataView.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit
import FindTownUI
import SnapKit

final class EmptySearchedDataView: UIView {
    
    let imageView = UIImageView()
    let noResultLabel = FindTownLabel(text: "검색결과가 없습니다.", font: .body1, textColor: .grey6)
    let proposePlaceButton = FTButton(style: .mediumFilled)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addView()
        setLayout()
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptySearchedDataView {
    
    func addView() {
        [imageView, noResultLabel, proposePlaceButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setView() {
        imageView.image = UIImage(named: "empty_data")
        proposePlaceButton.setTitle("장소 제안하기", for: .normal)
        proposePlaceButton.titleLabel?.font = FindTownFont.body3.font
        proposePlaceButton.setImage(UIImage(named: "icon_plus"), for: .normal)
    }
    
    func setLayout() {
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.centerX.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(12)
        }
        
        proposePlaceButton.snp.makeConstraints {
            $0.top.equalTo(noResultLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(152)
        }
    }
}
