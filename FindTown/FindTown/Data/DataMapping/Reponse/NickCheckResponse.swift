//
//  NickCheckResponse.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation
import FindTownNetwork

struct NickCheckResponse: Response {
    let existConfirm: ExistConfirm
    
    enum CodingKeys: String, CodingKey {
        case existConfirm = "exist_confirm"
    }
}

struct ExistConfirm: Response {
    let existence: Bool
}
