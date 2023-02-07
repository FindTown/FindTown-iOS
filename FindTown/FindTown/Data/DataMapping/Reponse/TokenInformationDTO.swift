//
//  TokenInformationDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/03.
//

import Foundation
import FindTownNetwork

struct TokenInformationDTO: Response {
    let accessToken: String
    let refreshToken: String
    let registerCheck: Int
    let accessTokenExpiredTime: Double
    let refreshTokenExpiredTime: Double
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case registerCheck = "register_check"
        case accessTokenExpiredTime = "access_token_expiry"
        case refreshTokenExpiredTime = "refresh_token_expiry"
    }
}
