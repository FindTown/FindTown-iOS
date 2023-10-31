//
//  SearchedPlaceTableViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/10/31.
//

import UIKit
import FindTownUI
import SnapKit

final class SearchedPlaceTableViewCell: UITableViewCell {
    
    let tipImageView = UIImageView()
    let placeTitleLabel = FindTownLabel(text: "김밥25 강남 CGV",
                                        font: .body1,
                                        textColor: .black)
    let placeLocationLabel = FindTownLabel(text: "서울 강남구 강남대로100길 10",
                                           font: .body4,
                                           textColor: .grey5)
    let lineView = UIView()
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchedPlaceTableViewCell {
    func addView() {
        [tipImageView, placeTitleLabel, placeLocationLabel, lineView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func setView() {
        self.selectionStyle = .none
        tipImageView.image = UIImage(named: "Frame 2608708")
        lineView.backgroundColor = FindTownColor.grey3.color
    }
    
    func setLayout() {
        
        tipImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
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
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
