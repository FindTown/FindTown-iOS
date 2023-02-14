//
//  FilterBottomSheetType.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/08.
//

import UIKit

enum FilterSheetType {
    case Filter
    case Infra
    case Traffic
    
    var height: Double {
        switch self {
        case .Filter:
            return 0.87
        case .Infra:
            return 0.37
        case .Traffic:
            return 0.60
        }
    }
}

enum Traffic: CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case gyeonguijungang
    case gonghangcheoldo
    case suinbundang
    case sinrimseon
    case sinbundang
    case uisinseol
    
    var description: String {
        switch self {
        case .one:
            return "1호선"
        case .two:
            return "2호선"
        case .three:
            return "3호선"
        case .four:
            return "4호선"
        case .five:
            return "5호선"
        case .six:
            return "6호선"
        case .seven:
            return "7호선"
        case .eight:
            return "8호선"
        case .nine:
            return "9호선"
        case .gyeonguijungang:
            return "경의중앙"
        case .gonghangcheoldo:
            return "공항철도"
        case .suinbundang:
            return "수인분당"
        case .sinrimseon:
            return "신림선"
        case .sinbundang:
            return "신분당"
        case .uisinseol:
            return "우이신설"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .gyeonguijungang:
            return "경의중앙"
        case .gonghangcheoldo:
            return "공항철도"
        case .suinbundang:
            return "수인분당"
        case .sinrimseon:
            return "신림선"
        case .sinbundang:
            return "신분당"
        case .uisinseol:
            return "우이신설"
        }
    }
    
    var color: UIColor {
        switch self {
        case .one:
            return UIColor(red: 38, green: 60, blue: 150)
        case .two:
            return UIColor(red: 60, green: 180, blue: 74)
        case .three:
            return UIColor(red: 255, green: 115, blue: 0)
        case .four:
            return UIColor(red: 44, green: 158, blue: 222)
        case .five:
            return UIColor(red: 137, green: 54, blue: 224)
        case .six:
            return UIColor(red: 181, green: 80, blue: 11)
        case .seven:
            return UIColor(red: 105, green: 114, blue: 21)
        case .eight:
            return UIColor(red: 229, green: 30, blue: 110)
        case .nine:
            return UIColor(red: 209, green: 166, blue: 44)
        case .gyeonguijungang:
            return UIColor(red: 124, green: 196, blue: 165)
        case .gonghangcheoldo:
            return UIColor(red: 115, green: 182, blue: 228)
        case .suinbundang:
            return UIColor(red: 255, green: 206, blue: 51)
        case .sinrimseon:
            return UIColor(red: 125, green: 154, blue: 223)
        case .sinbundang:
            return UIColor(red: 167, green: 30, blue: 49)
        case .uisinseol:
            return UIColor(red: 179, green: 199, blue: 62)
        }
    }
    
    static func returnTrafficType(_ traffic: String) -> Traffic? {
        return self.allCases.first { $0.shortDescription == traffic }
    }
}
