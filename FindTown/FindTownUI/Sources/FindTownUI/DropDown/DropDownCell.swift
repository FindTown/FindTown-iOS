//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/29.
//

import Foundation
import UIKit


/// DropDown 터치 시 나타나는 TableViewCell
class DropDownCell: UITableViewCell {
    
    static let reuseIdentifier = "DropDownCell"
    
    var label: UILabel = {
        let label = UILabel()
        label.font = FindTownFont.label1.font
        label.textColor = FindTownColor.grey7.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var checkMarkImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark", in: .module, compatibleWith: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// 선택한 cell만 checkMark 보이도록
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkMarkImageview.isHidden = false
        } else {
            checkMarkImageview.isHidden = true
        }
    }
    
    /// cellForRowAt 에서 호출되는 메서드
    public func setUpCell(text: String) {
        setLayout()
        label.text = text
    }
}

private extension DropDownCell {
    
    func setLayout() {
        
        [label, checkMarkImageview].forEach {
            self.addSubview($0)
        }

        NSLayoutConstraint.activate([
            checkMarkImageview.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkMarkImageview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11.19),
            checkMarkImageview.widthAnchor.constraint(equalToConstant: 13.96),
            checkMarkImageview.heightAnchor.constraint(equalToConstant: 10.48)
        ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: checkMarkImageview.trailingAnchor, constant: 6.85)
        ])
    }
}

