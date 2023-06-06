//
//  FavoriteListResponseDTO.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/19.
//

import UIKit
import FindTownNetwork

struct FavoriteListResponseDTO: Response {
    let townList: [FavoriteList]
    
    var toEntity: [TownTableModel] {
        var tableModels: [TownTableModel] = []
        for townList in townList {
            let county = CityCode(rawValue: townList.objectId)?.village.rawValue ?? ""
            let countyIcon = CityCode(rawValue: townList.objectId)?.countyIcon ?? UIImage()
            
            let tableModel = TownTableModel(objectId: townList.objectId,
                                            county: county,
                                            countyIcon: countyIcon,
                                            wishTown: true,
                                            safetyRate: Double(0.0),
                                            moods: townList.convertTownMood,
                                            townFullTitle: townList.convertFullTitle)
            tableModels.append(tableModel)
        }
        return tableModels
    }
}

struct FavoriteList: Response {
    
    let objectId: Int
    let moods: [String]
    
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
        let townTitle = City(county: city.county, village: city.village).description
        return townTitle
    }
}
