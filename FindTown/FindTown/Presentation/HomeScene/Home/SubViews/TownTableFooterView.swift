//
//  ErrorView.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/15.
//

import UIKit

import FindTownUI
import RxCocoa
import RxSwift

protocol TownTableFooterViewDelegate: AnyObject {
    func didTapRetryButton()
}

final class TownTableFooterView: UIView {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: TownTableFooterViewDelegate?
    
    private let titleLabel = FindTownLabel(text: "", font: .body1, textColor: .grey6)
    private let subTitleLabel = FindTownLabel(text: "", font: .body4, textColor: .grey5)
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = FindTownColor.back2.color
        
        [iconImageView, titleLabel, subTitleLabel].forEach {
            addSubview($0)
        }
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNetworkErrorView() {
        self.titleLabel.text = "인터넷 연결을 확인해보세요"
        self.subTitleLabel.text = "네트워크 연결 상태를 확인하고 다시 시도해주세요"
        iconImageView.image = UIImage(named: "networkError")
    }
    
    func setFilterEmptyView() {
        self.titleLabel.text = "필터에 해당하는 동네가 없어요"
        self.subTitleLabel.text = "다른 필터로 검색해 볼까요?"
        iconImageView.image = UIImage(named: "question")
    }
}
