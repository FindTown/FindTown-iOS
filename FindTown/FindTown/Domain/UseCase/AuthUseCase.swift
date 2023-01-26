//
//  AuthUseCase.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import AuthenticationServices

enum AuthType {
    case kakao, apple
}

final class AuthUseCase {
    
    let kakaoAuthRepository: DefaultKakaoAuthRepository
    let appleAuthRespository: DefaultAppleAuthRespository
    let authRepository: DefaultAuthRepository
    
    init() {
        self.kakaoAuthRepository = DefaultKakaoAuthRepository()
        self.appleAuthRespository = DefaultAppleAuthRespository()
        self.authRepository = DefaultAuthRepository()
    }
    
    func login(authType: AuthType) async throws -> String {
        switch authType {
        case .kakao:
            let _ = try await kakaoAuthRepository.isKakaoTalkLoginAvailable()
            let userId = try await kakaoAuthRepository.getUserInformation()
            return try await authRepository.login(memberId: String(userId))
        case .apple:
            let userId = try await appleAuthRespository.loginWithApple()
            print(userId)
            return ""
        }
    }
    
    func checkNicknameDuplicate(nickName: String) async throws -> Bool {
       return try await authRepository.checkNickNameDuplicate(nickName)
    }
    
    func getAppleAuthorizationController() -> ASAuthorizationController {
        return appleAuthRespository.authorizationController
    }
    
}
