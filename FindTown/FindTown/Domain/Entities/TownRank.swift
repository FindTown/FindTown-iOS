//
//  TownRank.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/30.
//

import Foundation
import UIKit

enum TownRank: String, CaseIterable {
    case lifeSafety = "lifeSafety"
    case crime = "crime"
    case traffic = "traffic"
    case livable = "livable"
    case popular = "popular"
    case clean = "clean"
    case safety = "safety"
    
    var description: String {
        switch self {
        case .lifeSafety:
            return "생활 안전 지수"
        case .crime:
            return "범죄 지수"
        case .traffic:
            return "교통 지수"
        case .livable:
            return "살기 좋은 동네"
        case .popular:
            return "인기 동네"
        case .clean:
            return "청결도"
        case .safety:
            return "치안"
        }
    }
    
    var image: UIImage {
        switch self {
        case .lifeSafety:
            return UIImage(named: "Policy") ?? UIImage()
        case .crime:
            return UIImage(named: "Warning") ?? UIImage()
        case .traffic:
            return UIImage(named: "Local taxi") ?? UIImage()
        case .livable:
            return UIImage(named: "Emoji emotions") ?? UIImage()
        case .popular:
            return UIImage(named: "Home work") ?? UIImage()
        case .clean:
            return UIImage(named: "Eco") ?? UIImage()
        case .safety:
            return UIImage(named: "Policy-2") ?? UIImage()
        }
    }
    
    static func returnTownRankType(_ mood: String) -> TownRank? {
        return self.allCases.first { $0.rawValue == mood }
    }
}
