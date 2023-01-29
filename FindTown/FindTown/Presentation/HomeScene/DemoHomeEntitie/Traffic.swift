//
//  Traffic.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import Foundation

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
    
    static func returnTrafficType(_ traffic: String) -> Traffic? {
        return self.allCases.first { $0.shortDescription == traffic }
    }
}
