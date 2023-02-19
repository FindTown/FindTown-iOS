//
//  LoginConfirmReponseDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct LoginConfirmReponseDTO: Response {
    let loginConfirm: MemberAuthroize
    
    enum CodingKeys: String, CodingKey {
        case loginConfirm = "login_confirm"
    }
}

struct MemberAuthroize: Response {
    let authorities: [AuthoritiesDTO]
    let memberId: String
}

struct AuthoritiesDTO: Response {
    let authority: String
}
