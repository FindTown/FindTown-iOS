//
//  ThemaCategory.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import UIKit

enum ThemaCategory: CaseIterable, Category {
    case every
    case restaurantForEatingAlone
    case cafeForStudy
    
    var description: String {
        switch self {
        case .restaurantForEatingAlone:
            return "혼밥하기 좋은 식당"
        case .cafeForStudy:
            return "카공하기 좋은 카페"
        case .every:
            return "전체"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .restaurantForEatingAlone:
            return UIImage(named: "thema.restaurant")
        case .cafeForStudy:
            return UIImage(named: "thema.notebook")
        case .every:
            return nil
        }
    }
    
    var code: String {
        switch self {
        case .cafeForStudy:
            return "001"
        case .restaurantForEatingAlone:
            return "002"
        case .every:
            return ""
        }
    }
}
