//
//  SignupUserModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/18.
//

import Foundation

struct SignupUserModel {
    var nickname: String
    var dongYearMonth: DongYearMonth
    var jachiguDong: JachiguDong
    var townLikeText: String
    
    init(nickname: String = "", dongYearMonth: DongYearMonth = .init(),
         jachiguDong: JachiguDong = .init(), townLikeText: String = ""
    ) {
        self.nickname = nickname
        self.dongYearMonth = dongYearMonth
        self.jachiguDong = jachiguDong
        self.townLikeText = townLikeText
    }
}

struct JachiguDong {
    let jachigu: String
    let dong: String
    
    init(jachigu: String = "", dong: String = "") {
        self.jachigu = jachigu
        self.dong = dong
    }
}

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
