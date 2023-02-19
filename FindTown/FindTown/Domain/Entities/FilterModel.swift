//
//  FilterModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/08.
//

import Foundation

struct FilterModel {
    var infra: String = ""
    var traffic: [String] = []
    var trafficIndexPath: [IndexPath] = []
    
    var toFilterStatus: String {
        switch infra {
        case "편의시설":
            return "convenience"
        case "의료":
            return "medical"
        case "운동":
            return "exercise"
        case "자연":
            return "greenery"
        default:
            return ""
        }
    }
}
