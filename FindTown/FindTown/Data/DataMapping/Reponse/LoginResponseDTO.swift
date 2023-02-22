//
//  LoginResponseDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/22.
//

import Foundation
import FindTownNetwork

struct LoginResponseDTO: Response {
    let loginStatus: Bool
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiredTime: Double
    let refreshTokenExpiredTime: Double
    let cookieMaxAgeForAccess: Double
    let cookieMaxAge: Double
    
    enum CodingKeys: String, CodingKey {
        case loginStatus = "login_status"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case accessTokenExpiredTime = "access_token_expiry"
        case refreshTokenExpiredTime = "refresh_token_expiry"
        case cookieMaxAgeForAccess = "cookie_max_age_for_access"
        case cookieMaxAge = "cookie_max_age"
    }
}
