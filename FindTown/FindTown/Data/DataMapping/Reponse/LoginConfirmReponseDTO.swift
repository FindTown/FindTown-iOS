//
//  LoginConfirmReponseDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct LoginConfirmReponseDTO: Response {
    let data: MemberAuthroize
    
    enum CodingKeys: String, CodingKey {
        case data = ""
    }
}

struct MemberAuthroize: Response {
    let memberAuthorizeData: [AuthoritiesDTO]
    let memberId: String
    
    enum CodingKeys: String, CodingKey {
        case memberAuthorizeData = "회원 권한 정보"
        case memberId = "회원 id"
    }
}

struct AuthoritiesDTO: Response {
    let authority: String
}
