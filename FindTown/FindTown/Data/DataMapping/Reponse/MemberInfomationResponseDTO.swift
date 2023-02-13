//
//  UserInfomationDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

struct MemberInfomationResponseDTO: Response {
    let memberInfomation: MemberInfomationDTO
    
    enum CodingKeys: String, CodingKey {
        case memberInfomation = "member_info"
    }
}

struct MemberInfomationDTO: Response {
    let memberId: String
    let email: String
    let nickname: String
    let providerType: String
    let resident: Resident
    let useAgreeYn: Bool
    let privacyAgreeYn: Bool
    let locationList: [Location]
    
    struct Resident: Response {
        let residentAddress: String
        let residentReview: String
        let residentYear: Int
        let residentMonth: Int
        
        var toEntity: ReviewModel {
            return ReviewModel(village: residentAddress,
                               period: "\(residentYear)년 \(residentMonth)개월 거주",
                               introduce: residentReview)
        }
    }
    
    struct Location: Response {
        let objectId: Int
        let admNm: String
        let admCd: String
        let admCd2: String
        let sido: String
        let sidoNm: String
        let sgg: String
        let sggNm: String
        let admCd8: String
        let coordinates: String
    }
}
