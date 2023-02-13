//
//  InfraCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import UIKit

protocol MCategory {
    var description: String { get }
    var image: UIImage? { get }
    var code: String { get }
}

enum InfraCategory: CaseIterable, MCategory {
    case martOrConvenienceStore
    case cafe
    case security
    case life
    case exercise
    case park
    case hospital
    case pharmacy
    
    var description: String {
        switch self {
        case .martOrConvenienceStore:
            return "마트&편의점"
        case .cafe:
            return "카페"
        case .security:
            return "치안"
        case .life:
            return "생활"
        case .exercise:
            return "운동"
        case .park:
            return "산책"
        case .hospital:
            return "병원"
        case .pharmacy:
            return "약국"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .martOrConvenienceStore:
            return UIImage(named: "martIcon")
        case .cafe:
            return UIImage(named: "infra.cafe.icon")
        case .security:
            return UIImage(named: "bellIcon")
        case .life:
            return UIImage(named: "storeIcon")
        case .exercise:
            return UIImage(named: "healthIcon")
        case .park:
            return UIImage(named: "walkIcon")
        case .hospital:
            return UIImage(named: "hospitalIcon")
        case .pharmacy:
            return UIImage(named: "pharmacyIcon")
        }
    }
    
    var code: String {
        switch self {
        case .martOrConvenienceStore:
            return "001"
        case .cafe:
            return "002"
        case .security:
            return "003"
        case .life:
            return "004"
        case .exercise:
            return "005"
        case .park:
            return "006"
        case .hospital:
            return "007"
        case .pharmacy:
            return "008"
        }
    }
}
