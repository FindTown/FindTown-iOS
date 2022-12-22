//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/20.
//

import Foundation
import UIKit

/// FindTown 프로젝트에서 사용되는 Custom Label
public final class FindTownLabel: UILabel {
    
    /// textColor = black, textAlignment = left로 default 설정
    public init(text: String,
                font: FindTownFont,
                textColor: FindTownColor = .black,
                textAlignment: NSTextAlignment = .left) {
                    
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.setupView(text: text,
                       font: font,
                       textColor: textColor,
                       textAlignment: textAlignment)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FindTownLabel {
    
    func setupView(text: String,
                   font: FindTownFont,
                   textColor: FindTownColor,
                   textAlignment: NSTextAlignment) {
        
        self.font = font.font
        self.textColor = textColor.color
        self.text = text
        self.textAlignment = textAlignment
    }
}
