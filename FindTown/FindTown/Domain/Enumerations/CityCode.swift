//
//  CityCode.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation

enum CityCode: Int, CaseIterable {
    case code01 = 01
    case code02 = 02
    case code03 = 03
    
    init?(county: County, village: Village) {
        for value in CityCode.allCases
        where value.county == county && value.village == village {
            self = value
            return
        }
        return nil
    }
    
    var county: County {
        return self.cityModel.county
    }
    
    var village: Village {
        return self.cityModel.village
    }
    
    var cityModel: CityMapping {
        switch self {
        case .code01:
            return .gangnam(.yeoksam1)
        case .code02:
            return .gangnam(.nonhyeon)
        case .code03:
            return .gangseo(.gayang1)
        }
    }
}
