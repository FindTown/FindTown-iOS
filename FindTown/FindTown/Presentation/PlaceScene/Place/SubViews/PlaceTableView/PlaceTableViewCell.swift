//
//  PlaceTableViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/12/03.
//

import UIKit

import FindTownUI

import SnapKit

final class PlaceTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    let placeTipImageView = UIImageView()
    let placeTitleLabel = FindTownLabel(text: "미정국수0410 멸치국수 잘하는집 신촌점 미정국수0410", font: .body1)
    let viewMoreButton = UIButton()
    let placeReviewView = UIView()
    let reviewStackView = UIStackView()
    let nameAndTimeView = UIView()
    let nameLabel = FindTownLabel(text: "맛집왕님", font: .body3, textColor: .grey7)
    let timeLabel = FindTownLabel(text: "1시간 전", font: .label2, textColor: .grey5)
    let reviewLabel = FindTownLabel(text: "매장이 넓고 자리도 많아서 혼밥하기 딱 좋은 장소에요! 메뉴도 종류가 많아서 뭐먹을지 고민될 때에 방문하면 좋아요. 특히 오므라이스가 맛있었...",
                                    font: .body3, textColor: .grey7)

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Any) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: 0,
                                                                     bottom: 32,
                                                                     right: 0))
    }
}

extension PlaceTableViewCell {
    func addView() {
        [placeTipImageView,
         placeTitleLabel,
         viewMoreButton,
         placeReviewView].forEach {
            contentView.addSubview($0)
        }
        
//        [nameAndTimeView, reviewLabel].forEach {
////            reviewStackView.addArrangedSubview($0)
//            placeReviewView.addSubview($0)
//        }
//        
//        
////        placeReviewView.addSubview(reviewStackView)
//        
//        [nameLabel, timeLabel].forEach {
//            nameAndTimeView.addSubview($0)
//        }
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        placeTipImageView.image = UIImage(named: "placeTip")
        viewMoreButton.setTitle("리뷰 3개", for: .normal)
        viewMoreButton.titleLabel?.font = FindTownFont.body3.font
        viewMoreButton.setTitleColor(FindTownColor.grey6.color, for: .normal)
        viewMoreButton.setImage(UIImage(named: "Icon_Navi"), for: .normal)
        viewMoreButton.semanticContentAttribute = .forceRightToLeft
        
        placeReviewView.backgroundColor = .white
        placeReviewView.layer.cornerRadius = 8
        placeReviewView.layer.borderWidth = 1
        placeReviewView.layer.borderColor = FindTownColor.back3.color.cgColor
        placeReviewView.layer.addCustomShadow(shadowX: 0,
                                              shadowY: 2,
                                              shadowColor: FindTownColor.grey5.color,
                                              blur: 3.0,
                                              spread: 0.0,
                                              alpha: 0.2)
        
        reviewStackView.axis = .vertical
        reviewStackView.spacing = 6
        reviewLabel.numberOfLines = 2
    }
    
    func setLayout() {
        placeTipImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.top.leading.equalTo(contentView)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(placeTipImageView.snp.trailing).offset(4)
            $0.trailing.equalTo(viewMoreButton.snp.leading).offset(-14)
            $0.centerY.equalTo(placeTipImageView)
        }
        
        viewMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(placeTipImageView)
            $0.trailing.equalTo(contentView)
        }
        
        placeReviewView.snp.makeConstraints {
            $0.top.equalTo(placeTipImageView.snp.bottom).offset(16.0)
            $0.leading.trailing.bottom.equalTo(contentView)
            $0.height.equalTo(200)
        }
//        
//        nameAndTimeView.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview().inset(24.0)
//        }
//
//        nameLabel.snp.makeConstraints {
//            $0.top.leading.equalTo(nameAndTimeView)
//        }
//     
//        timeLabel.snp.makeConstraints {
//            $0.leading.equalTo(nameLabel.snp.trailing).offset(6)
//            $0.centerY.equalTo(nameLabel)
//        }
//        
//        reviewLabel.snp.makeConstraints {
//            $0.leading.trailing.equalTo(nameAndTimeView)
//            $0.top.equalTo(nameAndTimeView.snp.bottom).offset(16)
//            $0.bottom.equalToSuperview().inset(24)
//        }
//        
//        reviewLabel.backgroundColor = .yellow
    }
}
