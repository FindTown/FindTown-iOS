//
//  PlaceInfoView.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/01.
//

import UIKit

import FindTownUI
import SnapKit

class PlaceInfoView: UIView {
    
    let tipImageView = UIImageView()
    let placeTitleLabel = FindTownLabel(text: "김밥25 강남CGV점", font: .body1)
    let placeLocationLabel = FindTownLabel(text: "서울 강남구 강남대로100길 10",
                                           font: .body4,
                                           textColor: .grey5)
    
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

extension PlaceInfoView {
    func addView() {
        [tipImageView, placeTitleLabel, placeLocationLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        
        self.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        tipImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(20)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(tipImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(tipImageView)
        }
        
        placeLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(placeTitleLabel)
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(6)
        }
    }
    
    func setView() {
        self.backgroundColor = FindTownColor.grey2.color
        tipImageView.image = UIImage(named: "Frame 2608708")
        self.layer.cornerRadius = 8
    }
}
