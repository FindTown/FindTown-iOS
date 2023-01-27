//
//  DefaultAppleAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import AuthenticationServices
import FindTownNetwork

final class DefaultAppleAuthRespository: NSObject {
    
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
    
    func checkAutoSign(userId: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userId) { credentialState, error in
                switch credentialState {
                  case .authorized:
                    continuation.resume(returning: true)
                    break
                  case .revoked:
                    continuation.resume(returning: false)
                    break
                  case .notFound:
                    continuation.resume(returning: false)
                    break
                  default:
                    continuation.resume(returning: false)
                    break
                  }
            }
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authcontinuation?.resume(throwing: error)
    }
}
