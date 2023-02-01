//
//  DemoInfomationCell.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownUI

final class InfoSectionCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var model: MyPageSection.Info?
    
    private let titleLabel: FindTownLabel = FindTownLabel(text: "", font: .body1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: MyPageSection.Info) {
        
        self.model = model
        let index = model.index
        
        if index == 0 || index == 4 || index == 5 {
            titleLabel.font = FindTownFont.body3.font
            titleLabel.textColor = FindTownColor.grey5.color
        }
        titleLabel.text = model.title
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(cellTap(sender:)))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func cellTap(sender: UITapGestureRecognizer) {
        model?.action()
    }
}
