//
//  StoreType.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation

struct StoreType: Decodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name, address,
        case latitude = "x"
        case longitude = "y"
    }
}
