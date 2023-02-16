//
//  ErrorView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/15.
//

import UIKit

import FindTownUI

protocol TownTableFooterViewDelegate: AnyObject {
    func didTapRetryButton()
}

final class TownTableFooterView: UIView {
    
    weak var delegate: TownTableFooterViewDelegate?
    
    private let titleLabel = FindTownLabel(text: "", font: .body1, textColor: .grey6)
    private let subTitleLabel = FindTownLabel(text: "", font: .body4, textColor: .grey5)
    private let retryButton = FTButton(style: .largeFilled)
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = FindTownColor.back2.color
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [iconImageView, titleLabel, subTitleLabel, retryButton].forEach {
            addSubview($0)
        }
        
        retryButton.setTitle("다시 시도하기", for: .normal)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24),
            retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        retryButton.isSelected = true
        retryButton.configuration?.contentInsets.leading = 12.0
        retryButton.configuration?.contentInsets.trailing = 12.0
    }
    
    @objc private func didTapRetryButton() {
        delegate?.didTapRetryButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNetworkErrorView() {
        self.titleLabel.text = "인터넷 연결을 확인해보세요"
        self.subTitleLabel.text = "네트워크 연결 상태를 확인하고 다시 시도해주세요"
        iconImageView.image = UIImage(named: "networkError")
        retryButton.isHidden = false
        
        let retryTap = UITapGestureRecognizer(target: self, action: #selector(didTapRetryButton))
        retryButton.isUserInteractionEnabled = true
        retryButton.addGestureRecognizer(retryTap)
    }
    
    func setFilterEmptyView() {
        self.titleLabel.text = "필터에 해당하는 동네가 없어요"
        self.subTitleLabel.text = "다른 필터로 검색해 볼까요?"
        iconImageView.image = UIImage(named: "question")
        retryButton.isHidden = true
    }
}
