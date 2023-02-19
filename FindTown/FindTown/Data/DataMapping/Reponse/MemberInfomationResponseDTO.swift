//
//  UserInfomationDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//
import Foundation
import FindTownNetwork

struct MemberInformationResponseDTO: Response {
    let memberInfomation: MemberInformationDTO
    
    enum CodingKeys: String, CodingKey {
        case memberInfomation = "member_info"
    }
}

struct MemberInformationDTO: Response {
    let memberId: String
    let email: String
    let nickname: String
    let providerType: String
    let resident: [Resident]
    let useAgreeYn: Bool
    let privacyAgreeYn: Bool
    let locationList: [Location]
    
    struct Resident: Response {
        let residentAddress: String
        let residentReview: String
        let residentYear: Int
        let residentMonth: Int
    }
    
    struct Location: Response {
        let objectId: Int
        let sidoNm: String
        let sggNm: String
        let admNm: String
    }
}
