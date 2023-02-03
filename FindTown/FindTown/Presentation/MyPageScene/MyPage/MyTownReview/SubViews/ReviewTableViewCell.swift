//
//  ReviewTableViewCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import UIKit

import FindTownUI

final class ReviewTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Views
    
    private let villageTitle = FindTownLabel(text: "", font: .subtitle4)
    
    private let period = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    
    private let guideIntroduceTitle = FindTownLabel(text: "살고 있는 동네는 어떤가요?", font: .body1)
    
    private let introduce = FindTownLabel(text: "", font: .label1, textColor: .grey6)
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8,
                                                                     left: 16,
                                                                     bottom: 8,
                                                                     right: 16))
    }
    
    // MARK: Functions
    
    private func addView() {
        [villageTitle, period, guideIntroduceTitle, introduce].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            villageTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            villageTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            period.topAnchor.constraint(equalTo: villageTitle.bottomAnchor, constant: 4),
            period.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            guideIntroduceTitle.topAnchor.constraint(equalTo: period.bottomAnchor, constant: 32),
            guideIntroduceTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            introduce.topAnchor.constraint(equalTo: guideIntroduceTitle.bottomAnchor, constant: 6),
            introduce.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            introduce.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            introduce.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupView() {
        backgroundColor = FindTownColor.back1.color
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = FindTownColor.white.color
        contentView.layer.addCustomShadow(shadowX: 0, shadowY: 2,
                                          shadowColor: FindTownColor.black.color.withAlphaComponent(0.4),
                                          blur: 10.0, spread: 0, alpha: 0.4)
        selectionStyle = .none
        
        introduce.numberOfLines = 0
    }
    
    func setupCell(_ model: Any) {
        guard let model = model as? reviewModelTest else { return }
        
        villageTitle.text = model.village
        
        period.text = model.period
        
        introduce.text = model.introduce
        
        guard let introduceText = introduce.text else { return }
        let attrString = NSMutableAttributedString(string: introduceText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        introduce.attributedText = attrString
    }
}
