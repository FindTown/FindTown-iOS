//
//  StoreDetailType.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/07.
//

import Foundation

enum StoreDetailType: CustomStringConvertible {
    case fastFood
    case koreanFood
    case westernFood
    case japanessFood
    case chinaFood
    
    var description: String {
        switch self {
        case .fastFood:
            return "간편식"
        case .koreanFood:
            return "한식"
        case .westernFood:
            return "양식"
        case .japanessFood:
            return "일식"
        case .chinaFood:
            return "중식"
        }
    }
}
