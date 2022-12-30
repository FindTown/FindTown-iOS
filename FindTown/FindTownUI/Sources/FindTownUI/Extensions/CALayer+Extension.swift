//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/29.
//

import Foundation
import UIKit

extension CALayer {

    // 피그마값으로 그림자 커스텀할 때 사용하는 함수
    func addCustomShadow(shadowX: Int,
                         shadowY: Int,
                         shadowColor: UIColor,
                         blur: CGFloat,
                         spread: CGFloat,
                         alpha: Float) {
        
        self.masksToBounds = false
        self.shadowColor = shadowColor.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.shadowRadius = blur / UIScreen.main.scale
        
        if spread == 0 {
            self.shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
