//
//  ChangeNicknameResponseDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/18.
//

import Foundation
import FindTownNetwork

struct ChangeNicknameResponseDTO: Response {
    let editSuccess: Bool
    
    enum CodingKeys: String, CodingKey {
        case editSuccess = "edit_nickname"
    }
}
