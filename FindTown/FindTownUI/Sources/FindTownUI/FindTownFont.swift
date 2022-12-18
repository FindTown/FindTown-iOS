//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/18.
//

import Foundation
import UIKit

// FindTown 프로젝트에서 사용되는 Font 타입 정의
public enum FindTownFont {
    case headLine1
    case headLine2
    case headLine3
    case subtitle1
    case subtitle2
    case subtitle3
    case subtitle4
    case subtitle5
    case body1
    case body2
    case body3
    case body4
    case label1
    case label2
    case label3
    case label4
}

extension FindTownFont {
    public var font: UIFont {
        switch self {
        case .headLine1:
            return UIFont.pretendard(type: .semiBold, size: 32.0)
        case .headLine2:
            return UIFont.pretendard(type: .semiBold, size: 28.0)
        case .headLine3:
            return UIFont.pretendard(type: .semiBold, size: 24.0)
        case .subtitle1:
            return UIFont.pretendard(type: .medium, size: 22.0)
        case .subtitle2:
            return UIFont.pretendard(type: .semiBold, size: 20.0)
        case .subtitle3:
            return UIFont.pretendard(type: .medium, size: 20.0)
        case .subtitle4:
            return UIFont.pretendard(type: .semiBold, size: 18.0)
        case .subtitle5:
            return UIFont.pretendard(type: .medium, size: 18.0)
        case .body1:
            return UIFont.pretendard(type: .medium, size: 16.0)
        case .body2:
            return UIFont.pretendard(type: .regular, size: 16.0)
        case .body3:
            return UIFont.pretendard(type: .medium, size: 14.0)
        case .body4:
            return UIFont.pretendard(type: .regular, size: 14.0)
        case .label1:
            return UIFont.pretendard(type: .regular, size: 14.0)
        case .label2:
            return UIFont.pretendard(type: .medium, size: 12.0)
        case .label3:
            return UIFont.pretendard(type: .light, size: 12.0)
        case .label4:
            return UIFont.pretendard(type: .light, size: 11.0)
        }
    }
}

// Pretendarad 폰트 종류
enum PretendardType {
    case regular
    case medium
    case semiBold
    case light

    var name: String {
        switch self {
        case .regular:
            return "Pretendard-Regular"
        case .medium:
            return "Pretendard-Medium"
        case .semiBold:
            return "Pretendard-SemiBold"
        case .light:
            return "Pretendard-Light"
        }
    }
}
