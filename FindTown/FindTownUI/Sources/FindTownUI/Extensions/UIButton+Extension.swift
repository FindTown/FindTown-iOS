//
//  File.swift
//  
//
//  Created by 이호영 on 2023/02/07.
//

import UIKit

public extension UIButton {
    func setUnderline(_ color: UIColor? = nil) {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        if let color = color {
            attributedString.addAttribute(.underlineColor,
                                          value: color,
                                          range: NSRange(location: 0, length: title.count)
            )
        }
        setAttributedTitle(attributedString, for: .normal)
    }
}
