//
//  TownRankView.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import UIKit
import FindTownUI

final class TownRankView: UIView {
    
    private let rankImageView = UIImageView()
    private let rankTitleLabel = FindTownLabel(text: "", font: .body1, textColor: .grey7)
    private let rankTextStackView = UIStackView()
    private let numberLabel = FindTownLabel(text: "", font: .headLine2, textColor: .grey7)
    private let leftTextLabel = FindTownLabel(text: "", font: .body3, textColor: .grey6)
    private let rightTextLabel = FindTownLabel(text: "등급", font: .body2, textColor: .grey7)
    
    convenience init(data: (TownRank,Any)) {
        self.init(frame: .zero)
        rankImageView.image = data.0.image
        rankTitleLabel.text = data.0.description
        
        switch data.0 {
        case .lifeRank:
            numberLabel.text = "\(data.1)"
        case .crimeRank:
            numberLabel.text = "\(data.1)"
        case .trafficRank:
            numberLabel.text = "\(data.1)"
        case .liveRank:
            numberLabel.text = "\(data.1)"
            rightTextLabel.text = "순위"
        case .popular:
            rightTextLabel.text = "위"
            guard let dic = data.1 as? [String] else { return }
            leftTextLabel.text = dic[0]
            numberLabel.text = dic[1]
        case .cleanRank:
            numberLabel.text = "\(data.1)"
            rightTextLabel.text = ""
        case .safety:
            rightTextLabel.text = "\(data.1)"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addView()
        setupLayout()
    }
}

private extension TownRankView {
    func setupView() {
        self.layer.cornerRadius = 16
        self.backgroundColor = FindTownColor.grey2.color
        rankTextStackView.axis = .horizontal
        rankTextStackView.spacing = 2
    }
    
    func addView() {
        [leftTextLabel, numberLabel, rightTextLabel].forEach {
            rankTextStackView.addArrangedSubview($0)
        }
        
        [rankImageView, rankTitleLabel, rankTextStackView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 192.0),
            rankImageView.widthAnchor.constraint(equalToConstant: 18.0),
            rankImageView.heightAnchor.constraint(equalToConstant: 18.0),
            rankImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            rankImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 19.0),
            rankTitleLabel.leadingAnchor.constraint(equalTo: rankImageView.trailingAnchor, constant: 6.0),
            rankTitleLabel.centerYAnchor.constraint(equalTo: rankImageView.centerYAnchor),
            rankTextStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            rankTextStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
        ])
        
        rankTextStackView.setCustomSpacing(8.0, after: leftTextLabel)
    }
}
