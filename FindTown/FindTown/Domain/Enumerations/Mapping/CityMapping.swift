//
//  TempCounty.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation

enum CityMapping: Equatable {
    
    case gangnam(Village.GangnamVillages)
    case gangseo(Village.GangseoVillages)
    case gwanak(Village.GwanakVillages)
    case gwangjin(Village.GwangjinVillages)
    case guro(Village.GuroVillages)
    case geumcheon(Village.GeumcheonVillages)
    case dongdaemun(Village.DongdaemunVillages)
    case dongjak(Village.DongjakVillages)
    case mapo(Village.MapoVillages)
    case seodaemun(Village.SeodaemunVillages)
    case seongbuk(Village.SeongbukVillages)
    case songpa(Village.SongpaVillages)
    case yeongdeungpo(Village.YeongdeungpoVillages)
    case jongno(Village.JongnoVillages)
    
    var county: County {
        switch self {
        case .gangnam:
            return .gangnam
        case .gangseo:
            return .gangseo
        case .gwanak:
            return .gwanak
        case .gwangjin:
            return .gwangjin
        case .guro:
            return .guro
        case .geumcheon:
            return .geumcheon
        case .dongdaemun:
            return .dongdaemun
        case .dongjak:
            return .dongjak
        case .mapo:
            return .mapo
        case .seodaemun:
            return .seodaemun
        case .seongbuk:
            return .seongbuk
        case .songpa:
            return .songpa
        case .yeongdeungpo:
            return .yeongdeungpo
        case .jongno:
            return .jongno
        }
    }
    
    var village: any Villages {
        switch self {
        case .gangnam(let gangnamVillages):
            return gangnamVillages
        case .gangseo(let gangseoVillages):
            return gangseoVillages
        case .gwanak(let gwanakVillages):
            return gwanakVillages
        case .gwangjin(let gwangjinVillages):
            return gwangjinVillages
        case .guro(let guroVillages):
            return guroVillages
        case .geumcheon(let geumcheonVillages):
            return geumcheonVillages
        case .dongdaemun(let dongdaemunVillages):
            return dongdaemunVillages
        case .dongjak(let dongjakVillages):
            return dongjakVillages
        case .mapo(let mapoVillages):
            return mapoVillages
        case .seodaemun(let seodaemunVillages):
            return seodaemunVillages
        case .seongbuk(let seongbukVillages):
            return seongbukVillages
        case .songpa(let songpaVillages):
            return songpaVillages
        case .yeongdeungpo(let yeongdeungpoVillages):
            return yeongdeungpoVillages
        case .jongno(let jongnoVillages):
            return jongnoVillages
        }
    }
}
