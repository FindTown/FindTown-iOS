//
//  Infra.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/13.
//

import Foundation

enum Infra: CaseIterable {
    case amenities
    case medical
    case exercise
    case nature
    
    var description: [String] {
        switch self {
        case .amenities:
            return ["imageName", "편의시설"]
        case .medical:
            return ["imageName", "의료"]
        case .exercise:
            return ["imageName", "운동"]
        case .nature:
            return ["imageName", "자연"]
        }
    }
}
