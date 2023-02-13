//
//  CityCode.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation

enum CityCode: Int, CaseIterable {
    case code365 = 365
    case code359 = 356
    case code251 = 251
    case code259 = 259
    case code336 = 336
    case code358 = 358
    case code321 = 321
    case code330 = 330
    case code326 = 326
    case code324 = 324
    case code322 = 322
    case code66 = 66
    case code263 = 263
    case code276 = 276
    case code92 = 92
    case code305 = 305
    case code211 = 211
    case code205 = 205
    case code113 = 113
    case code399 = 399
    case code301 = 301
    case code288 = 288
    case code291 = 291
    case code17 = 17
    
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
        case .code365:
            return .gangnam(.yeoksam1)
        case .code359:
            return .gangnam(.nonhyeon1)
        case .code251:
            return .gangseo(.gayang1)
        case .code259:
            return .gangseo(.hwagok)
        case .code336:
            return .gwanak(.cheongnyong)
        case .code358:
            return .gwanak(.sinsa)
        case .code321:
            return .gwanak(.haengun)
        case .code330:
            return .gwanak(.sillim)
        case .code326:
            return .gwanak(.seowon)
        case .code324:
            return .gwanak(.inheon)
        case .code322:
            return .gwanak(.nakseongdae)
        case .code66:
            return .gwangjin(.hwayang)
        case .code263:
            return .guro(.guro3)
        case .code276:
            return .geumcheon(.gasan)
        case .code92:
            return .dongdaemun(.imun)
        case .code305:
            return .dongjak(.sando1)
        case .code211:
            return .mapo(.seogyo)
        case .code205:
            return .seodaemun(.sinchon)
        case .code113:
            return .seongbuk(.anam)
        case .code399:
            return .songpa(.jamsilbon)
        case .code301:
            return .yeongdeungpo(.yeongdeungpo)
        case .code288:
            return .yeongdeungpo(.dangsan2)
        case .code291:
            return .yeongdeungpo(.singil1)
        case .code17:
            return .jongno(.hyehwa)
        }
    }
    
    var description: String {
        return "서울시 \(self.cityModel.county.rawValue) \(self.cityModel.village.rawValue)"
    }
}
