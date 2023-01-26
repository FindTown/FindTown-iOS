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
    var objectId: Int?
    var resident: Resident
    var useAgreeYn: Bool
    var privaxyAgreeYn: Bool
    
    init(memberId: String = "",
         email: String? = nil,
         providerType: ProviderType = .kakao,
         nickname: String = "",
         objectId: Int? = nil,
         resident: Resident = Resident(),
         useAgreeYn: Bool = false,
         privaxyAgreeYn: Bool = false
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
    var residentReview: String
    var residentYear: Int
    var residentMonth: Int
    var residentAddress: String
    
    init(residentReview: String = "",
         residentYear: Int = 0,
         residentMonth: Int = 0,
         residentAddress: String = "") {
        self.residentReview = residentReview
        self.residentYear = residentYear
        self.residentMonth = residentMonth
        self.residentAddress = residentAddress
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
