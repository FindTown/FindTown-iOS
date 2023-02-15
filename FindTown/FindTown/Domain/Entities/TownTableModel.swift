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
    let wishTown: Bool
    let safetyRate: Double
    let townIntroduction: String
}

func TownTableMockData() -> TownTableModel {
    return TownTableModel(objectId: 321,
                          county: "행운동",
                          countyIcon: UIImage(named: "gwanak") ?? UIImage(),
                          wishTown: false,
                          safetyRate: 3,
                          townIntroduction: "강남으로 출근하기 좋은 동네")
}
