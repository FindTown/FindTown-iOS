//
//  MemberResignDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/16.
//

import Foundation
import FindTownNetwork

struct MemberResignDTO: Response {
    let resignMember: Bool
    
    enum CodingKeys: String, CodingKey {
        case resignMember = "resign_member"
    }
}
