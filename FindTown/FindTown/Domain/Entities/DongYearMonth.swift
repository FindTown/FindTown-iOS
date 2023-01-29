//
//  SignupUserModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/18.
//

import Foundation

struct DongYearMonth {
    let dong: String
    let year: Int
    let month: Int

    init(dong: String = "", year: Int = 0, month: Int = 0) {
        self.dong = dong
        self.year = year
        self.month = month
    }
}
