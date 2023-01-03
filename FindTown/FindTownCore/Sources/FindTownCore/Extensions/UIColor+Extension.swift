//
//  File.swift
//  
//
//  Created by 장선영 on 2023/01/02.
//

import Foundation
import UIKit

public extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
}
