//
//  TownSearchResponseDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/18.
//

import UIKit
import FindTownNetwork

struct TownSearchResponseDTO: Response {
    let townInformations: [TownSearchInformationDTO]
    
    enum CodingKeys: String, CodingKey {
        case townInformations = "town_search"
    }
    
    var toEntity: [TownTableModel] {
        var tableModels: [TownTableModel] = []
        for townInformation in townInformations {
            let county = CityCode(rawValue: townInformation.objectId)?.village.rawValue ?? ""
            let countyIcon = CityCode(rawValue: townInformation.objectId)?.countyIcon ?? UIImage()
            let wishTown = townInformation.wishTown
            let safetyRate = 0.0
            let tableModel = TownTableModel(objectId: townInformation.objectId,
                                            county: county,
                                            countyIcon: countyIcon,
                                            wishTown: wishTown,
                                            safetyRate: safetyRate,
                                            moods: townInformation.convertTownMood,
                                            townFullTitle: townInformation.convertFullTitle)
            tableModels.append(tableModel)
        }
        return tableModels
    }
}

struct TownSearchInformationDTO: Response {
    let objectId: Int
    let moods: [String]
    let wishTown: Bool
    
    var convertTownMood: [TownMood] {
        var townMoodArray: [TownMood] = []
        
        for mood in moods {
            if let mood = TownMood.returnTrafficType(mood) {
                townMoodArray.append(mood)
            }
        }
        return townMoodArray
    }
    
    var convertFullTitle: String {
        guard let city = CityCode.init(rawValue: objectId) else { return "" }
        let townTitle = City(county: city.county, village: city.village).countyDescription
        return townTitle
    }
}
