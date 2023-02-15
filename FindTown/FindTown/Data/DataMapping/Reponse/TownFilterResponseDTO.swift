//
//  FilterTownResponseDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import UIKit
import FindTownNetwork

struct TownFilterResponseDTO: Response {
    let townInformations: [TownFilterInformationDTO]
    
    enum CodingKeys: String, CodingKey {
        case townInformations = "town_filter"
    }
    
    var toEntity: [TownTableModel] {
        var tableModels: [TownTableModel] = []
        for townInformation in townInformations {
            let county = CityCode(rawValue: townInformation.objectId)?.village.rawValue ?? ""
            let countyIcon = CityCode(rawValue: townInformation.objectId)?.countyIcon ?? UIImage()
            let wishTown = townInformation.wishTown
            let safetyRate = townInformation.safetyRate
            let townIntroduction = townInformation.townIntroduction
            let tableModel = TownTableModel(objectId: townInformation.objectId,
                                            county: county,
                                            countyIcon: countyIcon,
                                            wishTown: wishTown,
                                            safetyRate: safetyRate,
                                            townIntroduction: townIntroduction)
            tableModels.append(tableModel)
        }
        return tableModels
    }
}

struct TownFilterInformationDTO: Response {
    let objectId: Int
    let townIntroduction: String
    let safetyRate: Double
    let lifeRate: Int
    let crimeRate: Int
    let trafficRate: Int
    let reliefYn: String
    let wishTown: Bool
}
