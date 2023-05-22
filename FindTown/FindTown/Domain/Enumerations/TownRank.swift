//
//  TownRank.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/30.
//

import Foundation
import UIKit

enum TownRank: String, CaseIterable {
    case lifeRank = "lifeRank"
    case crimeRank = "crimeRank"
    case trafficRank = "trafficRank"
    case liveRank = "liveRank"
    case popular = "popular"
    case cleanRank = "cleanRank"
    case safety = "safety"
    
    var description: String {
        switch self {
        case .lifeRank:
            return "생활 안전 지수"
        case .crimeRank:
            return "범죄 지수"
        case .trafficRank:
            return "교통 지수"
        case .liveRank:
            return "살기 좋은 동네"
        case .popular:
            return "인기 동네"
        case .cleanRank:
            return "청결도"
        case .safety:
            return "치안"
        }
    }
    
    var image: UIImage {
        switch self {
        case .lifeRank:
            return UIImage(named: "Policy") ?? UIImage()
        case .crimeRank:
            return UIImage(named: "Warning") ?? UIImage()
        case .trafficRank:
            return UIImage(named: "Local taxi") ?? UIImage()
        case .liveRank:
            return UIImage(named: "Emoji emotions") ?? UIImage()
        case .popular:
            return UIImage(named: "Home work") ?? UIImage()
        case .cleanRank:
            return UIImage(named: "Eco") ?? UIImage()
        case .safety:
            return UIImage(named: "Policy-2") ?? UIImage()
        }
    }
    
    static func returnTownRankType(_ mood: String) -> TownRank? {
        return self.allCases.first { $0.rawValue == mood }
    }
}

struct TownRankData {
    var liveRank: Int?
    var popular: [String]?
    var cleanRank: String?
    var safety: String?
    var lifeRank: Int
    var crimeRank: Int
    var trafficRank: Int
    
    func toArray() -> [(TownRank, Any)] {
        var array = [(TownRank, Any)]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label,
               let typeKey = TownRank.returnTownRankType(key) {
                switch child.value {
                case Optional<Any>.some(let value):
                    array.append((typeKey, value))
                default:
                    continue
                }
            }
        }
        return array
    }
}
