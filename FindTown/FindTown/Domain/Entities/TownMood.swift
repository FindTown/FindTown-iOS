//
//  TownMood.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import Foundation

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
    
    static func returnTrafficType(_ mood: String) -> TownMood? {
        return self.allCases.first { $0.description == mood }
    }
}
