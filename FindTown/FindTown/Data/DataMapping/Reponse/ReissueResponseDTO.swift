//
//  ReissueResponseDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct ReissueResponseDTO: Response {
    let accessTokenData: AccessTokenDTO
    let expiredTokenClaims: String?
    
    enum CodingKeys: String, CodingKey {
        case accessTokenData = "access_token"
        case expiredTokenClaims 
    }
}

struct AccessTokenDTO: Response {
    let token: String
    let id: String
    let tokenClaims: TokenClaimsDTO
}

struct TokenClaimsDTO: Response {
    let sub: String
    let role: String
    let exp: Int
}
