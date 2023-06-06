//
//  TownTableModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/15.
//

import UIKit

struct TownTableModel {
    let objectId: Int
    let county: String
    let countyIcon: UIImage
    var wishTown: Bool
    let safetyRate: Double
    let moods: [TownMood]
    let townFullTitle: String
}
