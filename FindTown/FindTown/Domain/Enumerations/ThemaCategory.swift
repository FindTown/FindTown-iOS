//
//  ThemaCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation

enum ThemaCategory: String {
    case cafeForStudy = "카공하기 좋은 카페"
    case restaurantForEatingAlone = "혼밥하기 좋은 식당"
    
    var code: String {
        switch self {
        case .cafeForStudy:
            return "001"
        case .restaurantForEatingAlone:
            return "002"
        }
    }
}
