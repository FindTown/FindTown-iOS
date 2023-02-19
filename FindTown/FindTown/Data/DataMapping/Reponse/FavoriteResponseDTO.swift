//
//  FavoriteResponseDTO.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/20.
//

import Foundation
import FindTownNetwork

struct FavoriteResponseDTO: Response {
    let wishTown: String
    
    var toStatus: Bool {
        wishTown == "찜 등록" ? true : false
    }
}
