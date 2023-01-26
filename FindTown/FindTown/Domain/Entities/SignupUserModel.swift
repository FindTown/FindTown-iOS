//
//  SignupUserModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/18.
//

import Foundation

struct SignupUserModel {
    var memberId: String
    var email: String?
    var providerType: ProviderType
    var nickname: String
    var objectId: Int
    var resident: Resident
    var useAgreeYn: String
    var privaxyAgreeYn: String
    
    init(memberId: String = "",
         email: String? = nil,
         providerType: ProviderType = .kakao,
         nickname: String = "",
         objectId: Int = 0,
         resident: Resident = Resident(),
         useAgreeYn: String = "",
         privaxyAgreeYn: String = ""
    ) {
        self.memberId = memberId
        self.email = email
        self.providerType = providerType
        self.nickname = nickname
        self.objectId = objectId
        self.resident = resident
        self.useAgreeYn = useAgreeYn
        self.privaxyAgreeYn = privaxyAgreeYn
    }
}

struct Resident {
    let residentReview: String
    let residentYear: Int
    let residentMonth: Int
    
    init(residentReview: String = "",
         residentYear: Int = 0,
         residentMonth: Int = 0) {
        self.residentReview = residentReview
        self.residentYear = residentYear
        self.residentMonth = residentMonth
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
