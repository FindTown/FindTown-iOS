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
        
        self.font = font.font
        self.textColor = textColor.color
        self.text = text
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension FindTownLabel {
     
    /// 행간이 추가되어야하는 경우 사용
    func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            style.alignment = self.textAlignment
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4,
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
