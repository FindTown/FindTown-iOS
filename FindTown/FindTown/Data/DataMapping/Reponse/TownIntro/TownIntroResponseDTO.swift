//
//  TownIntroReponseDTO.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/17.
//

import Foundation
import FindTownNetwork

struct TownIntroResponseDTO: Response {
    let townIntro: TownIntroDTO
    
    enum CodingKeys: String, CodingKey {
        case townIntro = "town_info"
    }
}

struct TownIntroDTO: Response {
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
