//
//  AppleAuthRespository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation
import AuthenticationServices

protocol AppleAuthRespository {
    var authorizationController: ASAuthorizationController { get set }
    func loginWithApple() async throws -> SigninUserModel
}
