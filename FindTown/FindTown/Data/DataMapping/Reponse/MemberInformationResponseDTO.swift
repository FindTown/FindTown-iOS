//
//  UserInfomationDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

struct MemberInformationResponseDTO: Response {
    let memberInformation: MemberInformationDTO
    
    enum CodingKeys: String, CodingKey {
        case memberInformation = "member_info"
    }
}

struct MemberInformationDTO: Response {
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
        let sidoNm: String
        let sggNm: String
    }
}
