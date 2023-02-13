//
//  TownMapLocationDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation
import FindTownNetwork

struct TownMapLocationDTO: Response {
    let locationInfo: LocationInformationDTO
    
    enum CodingKeys: String, CodingKey {
        case locationInfo = "location-info"
    }
}

struct LocationInformationDTO: Response {
    let objectId: Int
    let adminName: String
    let coordinates: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case objectId = "object_id"
        case adminName = "adm_nm"
        case coordinates
    }
}
