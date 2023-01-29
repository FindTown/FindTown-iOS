//
//  TownMoodCollectionViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit

import FindTownUI
import RxSwift

final class TownMoodCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
        
    // MARK: View
    
    private var townMoodLabel = FindTownLabel(text: "", font: .body4, textColor: .grey7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ data: TownMood) {
        
        switch data {
        case .walking1:
            townMoodLabel.text = "🧗 언덕이 많은"
            self.backgroundColor = UIColor(red: 248, green: 244, blue: 243)
        case .walking2:
            townMoodLabel.text = "🏘 골목이 많은"
            self.backgroundColor = UIColor(red: 231, green: 241, blue: 255)
        case .walking3:
            townMoodLabel.text = "👣 산책하기 좋은"
            self.backgroundColor = UIColor(red: 234, green: 246, blue: 242)
        case .walking4:
            townMoodLabel.text = "👮🏻 밤거리가 안전한"
            self.backgroundColor = UIColor(red: 255, green: 243, blue: 243)
        case .walking5:
            townMoodLabel.text = "🎤‍️️️️ 유흥가가 많은"
            self.backgroundColor = UIColor(red: 236, green: 236, blue: 236)
        case .walking6:
            townMoodLabel.text = "🚨‍️️️️ 밤거리가 위험한"
            self.backgroundColor = UIColor(red: 255, green: 243, blue: 243)
        case .price1:
            townMoodLabel.text = "💸 물가가 저렴한"
            self.backgroundColor = UIColor(red: 243, green: 238, blue: 253)
        case .price2:
            townMoodLabel.text = "🏢 집값이 비싼"
            self.backgroundColor = UIColor(red: 243, green: 238, blue: 253)
        case .mood1:
            townMoodLabel.text = "😌 차분한"
            self.backgroundColor = UIColor(red: 243, green: 251, blue: 255)
        case .mood2:
            townMoodLabel.text = "🔇 조용한"
            self.backgroundColor = UIColor(red: 251, green: 241, blue: 231)
        case .mood3:
            townMoodLabel.text = "🦥 여유로운"
            self.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        case .mood4:
            townMoodLabel.text = "🙉️ 번잡한"
            self.backgroundColor = UIColor(red: 243, green: 251, blue: 255)
        case .mood5:
            townMoodLabel.text = "😎 놀기 좋은"
            self.backgroundColor = UIColor(red: 255, green: 250, blue: 204)
        case .environment1:
            townMoodLabel.text = "✨ 깔끔한"
            self.backgroundColor = UIColor(red: 255, green: 252, blue: 238)
        case .environment2:
            townMoodLabel.text = "🏚 노후된"
            self.backgroundColor = UIColor(red: 255, green: 252, blue: 238)
        case .neighbor1:
            townMoodLabel.text = "👥 항상 사람이 많은"
            self.backgroundColor = UIColor(red: 229, green: 246, blue: 255)
        case .neighbor2:
            townMoodLabel.text = "👩🏻‍💼 직장인이 많은"
            self.backgroundColor = UIColor(red: 229, green: 246, blue: 255)
        case .neighbor3:
            townMoodLabel.text = "👩🏻‍💻 학생이 많은"
            self.backgroundColor = UIColor(red: 229, green: 246, blue: 255)
        case .traffic1:
            townMoodLabel.text = "🚘 교통이 편리한"
            self.backgroundColor = UIColor(red: 249, green: 241, blue: 251)
        case .traffic2:
            townMoodLabel.text = "😣 교통이 불편한"
            self.backgroundColor = UIColor(red: 249, green: 241, blue: 251)
        case .traffic3:
            townMoodLabel.text = "😤 교통정체가 심한"
            self.backgroundColor = UIColor(red: 249, green: 241, blue: 251)
        case .infra1:
            townMoodLabel.text = "🛵 배달시키기 좋은"
            self.backgroundColor = UIColor(red: 255, green: 246, blue: 224)
        case .infra2:
            townMoodLabel.text = "🏪 편의시설이 많은"
            self.backgroundColor = UIColor(red: 240, green: 250, blue: 237)
        case .infra3:
            townMoodLabel.text = "🍲 맛집이 많은"
            self.backgroundColor = UIColor(red: 255, green: 242, blue: 231)
        }
    }
}

private extension TownMoodCollectionViewCell {
    
    func setupView() {
        self.layer.cornerRadius = 13
    }
    
    func setupLayout() {
        [townMoodLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            townMoodLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.0),
            townMoodLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6.0),
            townMoodLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            townMoodLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}
