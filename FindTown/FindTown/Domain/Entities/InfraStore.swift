//
//  InfraStore.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/21.
//

import Foundation

struct InfraStore: Equatable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let subCategory: InfraSubCategory
}
