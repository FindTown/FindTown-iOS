//
//  SelectReasonTableViewCell.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/02.
//

import UIKit

import FindTownUI

import SnapKit

final class SelectReasonTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    let titleLabel = FindTownLabel(text: "👤  1인 테이블이 많아요.", font: .body4, textColor: .grey5)
        
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
                                                        top: 16,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        if selected {
            contentView.layer.borderColor = FindTownColor.primary.color.cgColor
            titleLabel.textColor = FindTownColor.primary.color
        } else {
            contentView.layer.borderColor = FindTownColor.grey3.color.cgColor
            titleLabel.textColor = FindTownColor.grey5.color
        }
    }
}

extension SelectReasonTableViewCell {
    
    func addView() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    func setupView() {
        self.selectionStyle = .none
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = FindTownColor.grey3.color.cgColor
    }
}
