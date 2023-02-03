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
    let accessTokenExpiredTime: Date
    let refreshToken: String
    let refreshTokenExpiredTime: Date
}
