//
//  TownFilterDTO.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation

struct TownFilterDTO: Encodable {
    let filterStatus: String
    let subwayList: [String]
}
