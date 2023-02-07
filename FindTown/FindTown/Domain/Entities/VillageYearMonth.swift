//
//  SignupUserModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/18.
//

import Foundation

struct VillageYearMonth {
    let village: String
    let year: Int
    let month: Int

    init(village: String = "", year: Int = 0, month: Int = 0) {
        self.village = village
        self.year = year
        self.month = month
    }
}
