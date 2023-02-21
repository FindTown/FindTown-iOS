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
            let townIntroduction = townList.townExplanation
            
            let tableModel = TownTableModel(objectId: townList.objectId,
                                            county: county,
                                            countyIcon: countyIcon,
                                            wishTown: true,
                                            safetyRate: Double(0.0),
                                            townIntroduction: townIntroduction)
            tableModels.append(tableModel)
        }
        return tableModels
    }
}

struct FavoriteList: Response {
    
    let objectId: Int
    let townExplanation: String
}
