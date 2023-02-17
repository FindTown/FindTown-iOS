//
//  MapThemaStoreResponseDTO.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/17.
//

import Foundation
import FindTownNetwork

struct MapThemaStoreResponseDTO: Response {
    let placeList: [ThemaStoreResponseDTO]
}

struct ThemaStoreResponseDTO: Response {
    let name: String
    let address: String
    let x: Double
    let y: Double
    let subCategory: String
    let foodCategory: String?
    
    func toEntity() -> ThemaStore {
        let subCategory = StoreDetailType(description: subCategory)
        return ThemaStore(name: name, address: address, latitude: x, longitude: y, subCategory: subCategory ?? StoreDetailType.cafe, foodCategory: foodCategory ?? nil)
    }
}
