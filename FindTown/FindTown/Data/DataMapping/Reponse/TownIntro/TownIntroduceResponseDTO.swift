//
//  TownIntroReponseDTO.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/17.
//

import Foundation
import FindTownNetwork

struct TownIntroduceResponseDTO: Response {
    let townIntroduce: TownIntroduceDTO
    
    enum CodingKeys: String, CodingKey {
        case townIntroduce = "town_info"
    }
}

struct TownIntroduceDTO: Response {
    let objectId: Int
    let townExplanation: String
    let reliefYn: String
    let lifeRate: Int
    let crimeRate: Int
    let trafficRate: Int
    let cleanlinessRank: String
    let liveRank: Int
    let popularTownRate: Int
    let popularGeneration: Int
    let wishTown: Bool
    let townSubwayList: [String]
    let townMoodList: [String]
    let townHotPlaceList: [String?]
}
