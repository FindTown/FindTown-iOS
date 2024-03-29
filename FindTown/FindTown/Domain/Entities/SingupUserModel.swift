//
//  SingupUserModel.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/27.
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
    var privacyAgreeYn: Bool
    
    init(memberId: String = "",
         email: String? = nil,
         providerType: ProviderType = .kakao,
         nickname: String = "",
         objectId: Int? = nil,
         resident: Resident = Resident(),
         useAgreeYn: Bool = false,
         privacyAgreeYn: Bool = false
    ) {
        self.memberId = memberId
        self.email = email
        self.providerType = providerType
        self.nickname = nickname
        self.objectId = objectId
        self.resident = resident
        self.useAgreeYn = useAgreeYn
        self.privacyAgreeYn = privacyAgreeYn
    }
    
    func toData() -> MemberSignupDTO {
        return MemberSignupDTO(memberId: memberId,
                               email: email,
                               providerType: providerType.description,
                               nickname: nickname,
                               objectId: objectId,
                               resident: resident.toData(),
                               useAgreeYn: useAgreeYn,
                               privacyAgreeYn: privacyAgreeYn)
    }
}

struct Resident {
    var residentReview: String
    var residentYear: Int
    var residentMonth: Int
    var residentAddress: String
    var moods: [String]
    
    init(residentReview: String = "",
         residentYear: Int = 0,
         residentMonth: Int = 0,
         residentAddress: String = "",
         moods: [String] = []) {
        self.residentReview = residentReview
        self.residentYear = residentYear
        self.residentMonth = residentMonth
        self.residentAddress = residentAddress
        self.moods = moods
    }
    
    func toData() -> ResidentDTO {
        return ResidentDTO(residentReview: residentReview,
                           residentYear: residentYear,
                           residentMonth: residentMonth,
                           residentAddress: residentAddress,
                           moods: moods)
    }
}
