//
//  StoreDetailType.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/07.
//

import UIKit

enum StoreDetailType: CustomStringConvertible {
    case fastFood
    case koreanFood
    case westernFood
    case japaneseFood
    case chineseFood
    case simpleFood
    case worldFood
    case cafe
    
    var description: String {
        switch self {
        case .fastFood:
            return "패스트푸드"
        case .koreanFood:
            return "한식"
        case .westernFood:
            return "양식"
        case .japaneseFood:
            return "일식"
        case .chineseFood:
            return "중식"
        case .simpleFood:
            return "간편식"
        case .worldFood:
            return "세계"
        case .cafe:
            return "카페"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .fastFood:
            return UIImage(named: "fastFoodIcon")
        case .koreanFood:
            return UIImage(named: "koreanFoodIcon")
        case .westernFood:
            return UIImage(named: "westernFoodIcon")
        case .japaneseFood:
            return UIImage(named: "japaneseFoodIcon")
        case .chineseFood:
            return UIImage(named: "chineseFoodIcon")
        case .simpleFood:
            return UIImage(named: "simpleFoodIcon")
        case .worldFood:
            return UIImage(named: "worldFoodIcon")
        case .cafe:
            return UIImage(named: "fcafeIcon")
        }
    }
}
