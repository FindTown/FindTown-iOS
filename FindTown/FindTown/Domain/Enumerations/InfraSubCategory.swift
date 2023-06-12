//
//  InfraSubCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/21.
//

import UIKit

enum InfraSubCategory: CaseIterable {
    case convenienceStore
    case supermarket
    case goceryStore
    case cafe
    case policeStation
    case safetyBell
    case cctv
    case daiso
    case fitnessCenter
    case pilates
    case sportsCenter
    case park
    case hospital
    case largeHospital
    case pharmacy
    
    init?(description: String) {
        for value in InfraSubCategory.allCases
        where value.description == description {
            self = value
            return
        }
        return nil
    }
    
    var description: String {
        switch self {
        case .convenienceStore:
            return "편의점"
        case .supermarket:
            return "대형마트"
        case .goceryStore:
            return "동네마트"
        case .cafe:
            return "카페"
        case .policeStation:
            return "경찰서"
        case .safetyBell:
            return "안심벨"
        case .cctv:
            return "CCTV"
        case .daiso:
            return "다이소"
        case .fitnessCenter:
            return "헬스장"
        case .pilates:
            return "필라테스"
        case .sportsCenter:
            return "체육시설"
        case .park:
            return "공원"
        case .hospital:
            return "병원"
        case .largeHospital:
            return "종합병원"
        case .pharmacy:
            return "약국"
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .convenienceStore:
            return UIColor(red: 1, green: 0.117, blue: 0.117, alpha: 1)
        case .supermarket:
            return UIColor(red: 1, green: 0.822, blue: 0.192, alpha: 1)
        case .goceryStore:
            return UIColor(red: 1, green: 0.552, blue: 0.025, alpha: 1)
        case .cafe:
            return UIColor(red: 0.758, green: 0.566, blue: 0.376, alpha: 1)
        case .policeStation:
            return UIColor(red: 0.142, green: 0.382, blue: 1, alpha: 1)
        case .safetyBell:
            return UIColor(red: 0.621, green: 0.75, blue: 1, alpha: 1)
        case .cctv:
            return UIColor(red: 0, green: 0.162, blue: 0.579, alpha: 1)
        case .daiso:
            return UIColor(red: 0.157, green: 0.498, blue: 0.522, alpha: 1)
        case .fitnessCenter:
            return UIColor(red: 0.4, green: 0.165, blue: 0.894, alpha: 1)
        case .pilates:
            return UIColor(red: 0.886, green: 0.15, blue: 0.95, alpha: 1)
        case .sportsCenter:
            return UIColor(red: 0.642, green: 0.586, blue: 0.983, alpha: 1)
        case .park:
            return UIColor(red: 0.275, green: 0.847, blue: 0.18, alpha: 1)
        case .hospital:
            return UIColor(red: 0.2, green: 0.76, blue: 1, alpha: 1)
        case .largeHospital:
            return UIColor(red: 0.07, green: 0.276, blue: 0.804, alpha: 1)
        case .pharmacy:
            return UIColor(red: 1, green: 0.533, blue: 0.841, alpha: 1)
        }
    }
    
    var imageName: String {
        switch self {
        case .convenienceStore:
            return "martIcon"
        case .supermarket:
            return "martIcon"
        case .goceryStore:
            return "martIcon"
        case .cafe:
            return "infra.cafe.icon"
        case .policeStation:
            return "bellIcon"
        case .safetyBell:
            return "bellIcon"
        case .cctv:
            return "bellIcon"
        case .daiso:
            return "storeIcon"
        case .fitnessCenter:
            return "healthIcon"
        case .pilates:
            return "healthIcon"
        case .sportsCenter:
            return "healthIcon"
        case .park:
            return "walkIcon"
        case .hospital:
            return "hospitalIcon"
        case .largeHospital:
            return "hospitalIcon"
        case .pharmacy:
            return "pharmacyIcon"
        }
    }
}
