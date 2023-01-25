//
//  County.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import Foundation

enum County: String, CaseIterable {
    case gangnam = "강남구"
    case gangseo = "강서구"
    case gwanak = "관악구"
    case gwangjin = "광진구"
    case guro = "구로구"
    case geumcheon = "금천구"
    case dongdaemun = "동대문구"
    case dongjak = "동작구"
    case mapo = "마포구"
    case seodaemun = "서대문구"
    case seongbuk = "성북구"
    case songpa = "송파구"
    case yeongdeungpo = "영등포구"
    case jongno = "종로구"
    
    var villages: [String] {
        switch self {
        case .gangnam:
            return ["역삼1동", "논현1동"]
        case .gangseo:
            return ["가양1동", "화곡1동"]
        case .gwanak:
            return ["청룡동", "신사동", "행운동", "대학동", "신림동", "서원동", "인헌동", "서림동", "낙성대동"]
        case .gwangjin:
            return ["화양동"]
        case .guro:
            return ["구로3동"]
        case .geumcheon:
            return ["가산동"]
        case .dongdaemun:
            return ["이문1동"]
        case .dongjak:
            return ["상도1동"]
        case .mapo:
            return ["서교동"]
        case .seodaemun:
            return ["신촌동"]
        case .seongbuk:
            return ["안암동"]
        case .songpa:
            return ["잠실본동"]
        case .yeongdeungpo:
            return ["영등포동", "당산2동", "신길1동"]
        case .jongno:
            return ["혜화동"]
        }
    }
}
