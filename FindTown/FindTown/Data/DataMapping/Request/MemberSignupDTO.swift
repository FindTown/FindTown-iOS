//
//  UserRegisterDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation

struct MemberSignupDTO: Encodable {
    var memberId: String
    var email: String?
    var providerType: String
    var nickname: String
    var objectId: Int?
    var resident: ResidentDTO
    var useAgreeYn: Bool
    var privacyAgreeYn: Bool
}

struct ResidentDTO: Encodable {
    var residentReview: String
    var residentYear: Int
    var residentMonth: Int
    var residentAddress: String
    var moods: [String]
}
