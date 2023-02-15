//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/07.
//

import UIKit

public extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func setUnderlineWithBottomPadding(_ paddingValue: Double = 2.0) {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = FindTownColor.grey6.color
        addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: paddingValue),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.widthAnchor.constraint(equalToConstant: intrinsicContentSize.width),
            line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingValue)
        ])
    }
}
