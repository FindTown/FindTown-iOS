//
//  InfraCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import UIKit

enum InfraCategory {
    case martOrConvenienceStore
    case cafe
    case security
    case life
    case exercise
    case park
    case hospital
    case pharmacy
    
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
//
//enum InfraCategoryType {
//    struct MartOrConvenienceStore: Decodable {
//        let convenienceStore: [StoreType]
//        let supermarket: [StoreType]
//
//        enum CodingKeys: String, CodingKey {
//            case convenienceStore = "편의점"
//            case supermarket=
//        }
//    }
//}
