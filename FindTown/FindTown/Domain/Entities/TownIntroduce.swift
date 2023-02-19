//
//  TTownIntroduce.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/19.
//

import Foundation

struct TownIntroduce {
    let townTitle: String
    let wishTown: Bool
    let townExplanation: String
    let townMood: [TownMood]
    let traffic: [Traffic]
    let hotPlace: [String]
    let townRank: [(TownRank,Any)]
}
