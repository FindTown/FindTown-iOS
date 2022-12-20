//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/16.
//

import Foundation
import UIKit

extension UIColor {
    // Asset에 등록된 Color 불러오는 메서드
    static func findTownColor(named: String) -> UIColor {
        guard let color = UIColor(named: named, in: .module, compatibleWith: nil) else {
            return .clear
        }
        return color
    }
}
