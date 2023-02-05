//
//  NickCheckResponse.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation
import FindTownNetwork

struct NickCheckResponseDTO: Response {
    let existConfirm: Bool
    
    enum CodingKeys: String, CodingKey {
        case existConfirm = "exist_confirm"
    }
}
