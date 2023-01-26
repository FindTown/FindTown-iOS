//
//  Village.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation

protocol Villages: CaseIterable { }

enum Village {
    enum GangnamVillages: String, Villages {
        case yeoksam1 = "역삼1동"
        case nonhyeon = "논현1동"
    }

    enum GangseoVillages: String, Villages {
        case gayang1 = "가양1동"
        case nonhyeon = "화곡1동"
    }
    
    enum GwanakVillages: String, Villages {
        case cheongnyong = "청룡동"
        case sinsa = "신사동"
        case haengun = "행운동"
        case daehak = "대학동"
        case sillim = "신림동"
        case seowon = "서원동"
        case inheon = "인헌동"
        case seorim = "서림동"
        case nakseongdae = "낙성대동"
    }
    
    enum GwangjinVillages: String, Villages {
        case hwayang = "화양동"
    }
    
    enum GuroVillages: String, Villages {
        case guro3 = "구로3동"
    }
    
    enum GeumcheonVillages: String, Villages {
        case gasan = "가산동"
    }
    
    enum DongdaemunVillages: String, Villages {
        case imun = "이문1동"
    }
    
    enum DongjakVillages: String, Villages {
        case sando1 = "상도1동"
    }
    
    enum MapoVillages: String, Villages {
        case seogyo = "서교동"
    }
    
    enum SeodaemunVillages: String, Villages {
        case sinchon = "신촌동"
    }
    
    enum SeongbukVillages: String, Villages {
        case anam = "안암동"
    }
    
    enum SongpaVillages: String, Villages {
        case jamsilbon = "잠실본동"
    }
    
    enum YeongdeungpoVillages: String, Villages {
        case yeongdeungpo = "영등포동"
        case dangsan2 = "당산2동"
        case singil1 = "신길1동"
    }
    
    enum JongnoVillages: String, Villages {
        case hyehwa = "혜화동"
    }
}
