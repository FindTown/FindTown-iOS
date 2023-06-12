//
//  StoreType.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation

struct ThemaStore: Equatable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let subCategory: StoreDetailType
    let foodCategory: String?
    let category: ThemaCategory
}
