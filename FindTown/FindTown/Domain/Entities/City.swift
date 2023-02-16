//
//  City.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/10.
//

import Foundation

struct City {
    let county: County
    let village: Village
    
    var description: String {
        return "서울시 \(self.county.rawValue) \(self.village.rawValue)"
    }
}
