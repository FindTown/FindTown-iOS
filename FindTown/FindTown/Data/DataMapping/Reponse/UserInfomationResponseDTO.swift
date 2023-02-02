//
//  UserInfomationDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

struct UserInfomationResponseDTO: Response {
    let userInfo: UserInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case userInfo = "member_info"
    }
}

struct UserInfoDTO: Response {
    let memberId: String
    let email: String
    let nickname: String
    let providerType: String
    let resident: Resident
    let useAgreeYn: Bool
    let privacyAgreeYn: Bool
    let locationList: [String]
    
    struct Resident: Response {
        let residentAddress: String
        let residentReview: String
        let residentYear: Int
        let residentMonth: Int
    }
}
