//
//  File.swift
//  
//
//  Created by 장선영 on 2022/12/18.
//

import Foundation
import UIKit

// FindTown 프로젝트에서 사용되는 Color 타입 정의
public enum FindTownColor {
    case back1
    case back2
    case back3
    case black
    case dim20
    case dim50
    case dim70
    case grey1
    case grey2
    case grey3
    case grey4
    case grey5
    case grey6
    case grey7
    case primary
    case primary10
    case secondary
    case white
    case error
    case success
}

extension FindTownColor {
    
    public var color: UIColor {
        switch self {
        case .back1:
            return UIColor.findTownColor(named: "Back1")
        case .back2:
            return UIColor.findTownColor(named: "Back2")
        case .back3:
            return UIColor.findTownColor(named: "Back3")
        case .black:
            return UIColor.findTownColor(named: "Black")
        case .dim20:
            return UIColor.findTownColor(named: "Dim20")
        case .dim50:
            return UIColor.findTownColor(named: "Dim50")
        case .dim70:
            return UIColor.findTownColor(named: "Dim70")
        case .grey1:
            return UIColor.findTownColor(named: "Grey1")
        case .grey2:
            return UIColor.findTownColor(named: "Grey2")
        case .grey3:
            return UIColor.findTownColor(named: "Grey3")
        case .grey4:
            return UIColor.findTownColor(named: "Grey4")
        case .grey5:
            return UIColor.findTownColor(named: "Grey5")
        case .grey6:
            return UIColor.findTownColor(named: "Grey6")
        case .grey7:
            return UIColor.findTownColor(named: "Grey7")
        case .primary:
            return UIColor.findTownColor(named: "Primary")
        case .primary10:
            return UIColor.findTownColor(named: "Primary10")
        case .secondary:
            return UIColor.findTownColor(named: "Secondary")
        case .white:
            return UIColor.findTownColor(named: "White")
        case .error:
            return UIColor.findTownColor(named: "Error")
        case .success:
            return UIColor.findTownColor(named: "Success")
        }
    }
}
