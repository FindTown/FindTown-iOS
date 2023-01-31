//
//  TownMood.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import Foundation
import UIKit

enum TownMood: CaseIterable {
    /// "언덕이 많은"
    case walking1
    /// "골목이 많은"
    case walking2
    /// "산책하기 좋은"
    case walking3
    /// "밤거리가 안전한"
    case walking4
    /// "유흥가가 많은"
    case walking5
    /// "밤거리가 위험한"
    case walking6
    /// "물가가 저렴한"
    case price1
    /// "집값이 비싼"
    case price2
    /// "차분한"
    case mood1
    /// "조용한"
    case mood2
    /// "여유로운"
    case mood3
    /// "번잡한"
    case mood4
    /// "놀기 좋은"
    case mood5
    /// "깔끔한"
    case environment1
    /// "노후된"
    case environment2
    /// "항상 사람이 많은"
    case neighbor1
    /// "직장인이 많은"
    case neighbor2
    /// "학생이 많은"
    case neighbor3
    /// "교통이 편리한"
    case traffic1
    /// "교통이 불편한"
    case traffic2
    /// "교통정체가 심한"
    case traffic3
    /// "배달시키기 좋은"
    case infra1
    /// "편의시설이 많은"
    case infra2
    /// "맛집이 많은"
    case infra3
    
    
    var description: String {
        switch self {
        case .walking1:
            return "언덕이 많은"
        case .walking2:
            return "골목이 많은"
        case .walking3:
            return "산책하기 좋은"
        case .walking4:
            return "밤거리가 안전한"
        case .walking5:
            return "유흥가가 많은"
        case .walking6:
            return "밤거리가 위험한"
        case .price1:
            return "물가가 저렴한"
        case .price2:
            return "집값이 비싼"
        case .mood1:
            return "차분한"
        case .mood2:
            return "조용한"
        case .mood3:
            return "여유로운"
        case .mood4:
            return "번잡한"
        case .mood5:
            return "놀기 좋은"
        case .environment1:
            return "깔끔한"
        case .environment2:
            return "노후된"
        case .neighbor1:
            return "항상 사람이 많은"
        case .neighbor2:
            return "직장인이 많은"
        case .neighbor3:
            return "학생이 많은"
        case .traffic1:
            return "교통이 편리한"
        case .traffic2:
            return "교통이 불편한"
        case .traffic3:
            return "교통정체가 심한"
        case .infra1:
            return "배달시키기 좋은"
        case .infra2:
            return "편의시설이 많은"
        case .infra3:
            return "맛집이 많은"
        }
    }
    
    var color: UIColor {
        switch self {
        case .walking1:
            return UIColor(red: 248, green: 244, blue: 243)
        case .walking2:
            return UIColor(red: 231, green: 241, blue: 255)
        case .walking3:
            return UIColor(red: 234, green: 246, blue: 242)
        case .walking4:
            return UIColor(red: 255, green: 243, blue: 243)
        case .walking5:
            return UIColor(red: 236, green: 236, blue: 236)
        case .walking6:
            return UIColor(red: 255, green: 243, blue: 243)
        case .price1:
            return UIColor(red: 243, green: 238, blue: 253)
        case .price2:
            return UIColor(red: 243, green: 238, blue: 253)
        case .mood1:
            return UIColor(red: 243, green: 251, blue: 255)
        case .mood2:
            return UIColor(red: 251, green: 241, blue: 231)
        case .mood3:
            return UIColor(red: 248, green: 248, blue: 248)
        case .mood4:
            return UIColor(red: 243, green: 251, blue: 255)
        case .mood5:
            return UIColor(red: 255, green: 250, blue: 204)
        case .environment1:
            return UIColor(red: 255, green: 252, blue: 238)
        case .environment2:
            return UIColor(red: 255, green: 252, blue: 238)
        case .neighbor1:
            return UIColor(red: 229, green: 246, blue: 255)
        case .neighbor2:
            return UIColor(red: 229, green: 246, blue: 255)
        case .neighbor3:
            return UIColor(red: 229, green: 246, blue: 255)
        case .traffic1:
            return UIColor(red: 249, green: 241, blue: 251)
        case .traffic2:
            return UIColor(red: 249, green: 241, blue: 251)
        case .traffic3:
            return UIColor(red: 249, green: 241, blue: 251)
        case .infra1:
            return UIColor(red: 255, green: 246, blue: 224)
        case .infra2:
            return UIColor(red: 240, green: 250, blue: 237)
        case .infra3:
            return UIColor(red: 255, green: 242, blue: 231)
        }
    }
    
    var emojiDescription: String {
        switch self {
        case .walking1:
            return "🧗 언덕이 많은"
        case .walking2:
            return "🏘 골목이 많은"
        case .walking3:
            return "👣 산책하기 좋은"
        case .walking4:
            return "👮🏻 밤거리가 안전한"
        case .walking5:
            return "🎤‍️️️️ 유흥가가 많은"
        case .walking6:
            return "🚨‍️️️️ 밤거리가 위험한"
        case .price1:
            return "💸 물가가 저렴한"
        case .price2:
            return "🏢 집값이 비싼"
        case .mood1:
            return "😌 차분한"
        case .mood2:
            return "🔇 조용한"
        case .mood3:
            return "🦥 여유로운"
        case .mood4:
            return "🙉️ 번잡한"
        case .mood5:
            return "😎 놀기 좋은"
        case .environment1:
            return "✨ 깔끔한"
        case .environment2:
            return "🏚 노후된"
        case .neighbor1:
            return "👥 항상 사람이 많은"
        case .neighbor2:
            return "👩🏻‍💼 직장인이 많은"
        case .neighbor3:
            return "👩🏻‍💻 학생이 많은"
        case .traffic1:
            return "🚘 교통이 편리한"
        case .traffic2:
            return "😣 교통이 불편한"
        case .traffic3:
            return "😤 교통정체가 심한"
        case .infra1:
            return "🛵 배달시키기 좋은"
        case .infra2:
            return "🏪 편의시설이 많은"
        case .infra3:
            return "🍲 맛집이 많은"
        }
    }
    
    static func returnTrafficType(_ mood: String) -> TownMood? {
        return self.allCases.first { $0.description == mood }
    }
}
