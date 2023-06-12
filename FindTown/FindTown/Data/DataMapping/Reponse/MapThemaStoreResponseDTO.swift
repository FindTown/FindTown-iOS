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
    
    func toThemaStoreEntity() -> ThemaStore {
        let subCategory = StoreDetailType(description: subCategory)
        if let foodCategory = foodCategory {
            return ThemaStore(
                name: name,
                address: address,
                latitude: y,
                longitude: x,
                subCategory: subCategory ?? StoreDetailType.cafe,
                foodCategory: foodCategory,
                category: .restaurantForEatingAlone
            )
        } else {
            return ThemaStore(
                name: name,
                address: address,
                latitude: y,
                longitude: x,
                subCategory: subCategory ?? StoreDetailType.cafe,
                foodCategory: nil,
                category: .cafeForStudy
            )
        }
        
    }
    
    func toInfraStoreEntity() -> InfraStore {
        let subCategory = InfraSubCategory(description: subCategory)
        return InfraStore(name: name, address: address, latitude: y, longitude: x, subCategory: subCategory ?? InfraSubCategory.convenienceStore)
    }
}
