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
            return Village.GangnamVillages.allCases.map { $0.rawValue }
        case .gangseo:
            return Village.GangseoVillages.allCases.map { $0.rawValue }
        case .gwanak:
            return Village.GwanakVillages.allCases.map { $0.rawValue }
        case .gwangjin:
            return Village.GwangjinVillages.allCases.map { $0.rawValue }
        case .guro:
            return Village.GuroVillages.allCases.map { $0.rawValue }
        case .geumcheon:
            return Village.GeumcheonVillages.allCases.map { $0.rawValue }
        case .dongdaemun:
            return Village.DongdaemunVillages.allCases.map { $0.rawValue }
        case .dongjak:
            return Village.DongjakVillages.allCases.map { $0.rawValue }
        case .mapo:
            return Village.MapoVillages.allCases.map { $0.rawValue }
        case .seodaemun:
            return Village.SeodaemunVillages.allCases.map { $0.rawValue }
        case .seongbuk:
            return Village.SeongbukVillages.allCases.map { $0.rawValue }
        case .songpa:
            return Village.SongpaVillages.allCases.map { $0.rawValue }
        case .yeongdeungpo:
            return Village.YeongdeungpoVillages.allCases.map { $0.rawValue }
        case .jongno:
            return Village.JongnoVillages.allCases.map { $0.rawValue }
        }
    }
}
