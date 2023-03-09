//
//  DefaultAppleAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import AuthenticationServices
import FindTownNetwork

final class DefaultAppleAuthRespository: NSObject, AppleAuthRespository {
    
    private var authcontinuation: CheckedContinuation<SigninUserModel, Error>?
    
    lazy var authorizationController: ASAuthorizationController = {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        return authorizationController
    }()
     
    func loginWithApple() async throws -> SigninUserModel {
        return try await withCheckedThrowingContinuation { continuation in
            authcontinuation = continuation
            authorizationController.performRequests()
        }
    }
}

extension DefaultAppleAuthRespository: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let signinUserModel = SigninUserModel(userId: appleIDCredential.user, email: appleIDCredential.email)
            authcontinuation?.resume(returning: signinUserModel)
        } else {
            authcontinuation?.resume(throwing: FTNetworkError.apple)
        }
    }
}
