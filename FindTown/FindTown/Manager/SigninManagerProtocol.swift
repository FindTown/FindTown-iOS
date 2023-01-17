//
//  SignUpManagerProtocol.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/04.
//

import Foundation

import RxSwift

protocol SigninManagerProtocol {
    func signin() -> Observable<SigninRequest>
    func signout() -> Observable<Void>
    func logout() -> Observable<Void>
}

// 따로 분리
struct SigninRequest {
    var signinType: SigninType
    var accessToken: String
    var refreshToken: String
    
    var params: [String : Any] {
        return [
            "signinType": self.signinType.rawValue,
            "accessToken": self.accessToken,
            "refreshToken": self.refreshToken,
        ]
    }
}

enum SigninType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case anonymous = "ANONYMOUS"
    case unknown
}
