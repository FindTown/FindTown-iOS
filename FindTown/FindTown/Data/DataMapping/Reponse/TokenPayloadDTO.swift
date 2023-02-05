//
//  TokenPayloadDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct TokenPayloadDTO: Response {
    let sub: String
    let exp: TimeInterval
}
