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
    
    var villages: [Village] {
        switch self {
        case .gangnam:
            return [.yeoksam1, .nonhyeon1]
        case .gangseo:
            return [.gayang1, .hwagok]
        case .gwanak:
            return [.cheongnyong, .sinsa, .haengun, .daehak, .sillim, .seowon, .inheon, .seorim, .nakseongdae]
        case .gwangjin:
            return [.hwayang]
        case .guro:
            return [.guro3]
        case .geumcheon:
            return [.gasan]
        case .dongdaemun:
            return [.imun]
        case .dongjak:
            return [.sando1]
        case .mapo:
            return [.seogyo]
        case .seodaemun:
            return [.sinchon, .yeonhui]
        case .seongbuk:
            return [.anam]
        case .songpa:
            return [.jamsilbon]
        case .yeongdeungpo:
            return [.yeongdeungpo, .dangsan2, .singil1]
        case .jongno:
            return [.hyehwa]
        }
    }
}
