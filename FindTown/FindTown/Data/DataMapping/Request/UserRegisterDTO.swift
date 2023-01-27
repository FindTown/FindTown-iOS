//
//  UserRegisterDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation

struct UserRegisterDTO: Encodable {
    var memberId: String
    var email: String?
    var providerType: ProviderType
    var nickname: String
    var objectId: Int?
    var resident: ResidentDTO
    var useAgreeYn: Bool
    var privaxyAgreeYn: Bool
}

struct ResidentDTO: Encodable {
    var residentReview: String
    var residentYear: Int
    var residentMonth: Int
    var residentAddress: String
}
