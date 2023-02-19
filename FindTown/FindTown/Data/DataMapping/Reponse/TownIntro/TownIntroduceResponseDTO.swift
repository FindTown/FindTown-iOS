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
    
    var convertTownTitle: String {
        guard let city = CityCode.init(rawValue: objectId) else { return "" }
        let townTitle = City(county: city.county, village: city.village).description
        return townTitle
    }
    
    var convertTownMood: [TownMood] {
        var townMoodArray: [TownMood] = []
        
        for mood in townMoodList {
            if let mood = TownMood.returnTrafficType(mood) {
                townMoodArray.append(mood)
            }
        }
        return townMoodArray
    }
    
    var convertTraffic: [Traffic] {
        
        var trafficArray: [Traffic] = []
      
        for traffic in townSubwayList {
            if let traffic =  Traffic.returnTrafficType(traffic) {
                trafficArray.append(traffic)
            }
        }
        
        return trafficArray
    }
    
    func convertTownRank() -> [(TownRank,Any)] {
        let popular = popularGeneration == 0 ? nil : ["\(popularGeneration)대 1인가구",
                                                        "\(popularTownRate)"]
        let townRankData = TownRankData(lifeRank: lifeRate,
                                        crimeRank: crimeRate,
                                        trafficRank: trafficRate,
                                        liveRank: liveRank == 0 ? nil : liveRank,
                                        popular: popular,
                                        cleanRank: cleanlinessRank == "N" ? nil : cleanlinessRank,
                                        safety: reliefYn == "Y" ? "안심보안관 활동지" : nil)
        
        return townRankData.toArray()
    }
}
