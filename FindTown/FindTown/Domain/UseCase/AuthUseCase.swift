//
//  AuthUseCase.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import AuthenticationServices

final class AuthUseCase {
    
    let kakaoAuthRepository: DefaultKakaoAuthRepository
    let appleAuthRespository: DefaultAppleAuthRespository
    let authRepository: DefaultAuthRepository
    
    init() {
        self.kakaoAuthRepository = DefaultKakaoAuthRepository()
        self.appleAuthRespository = DefaultAppleAuthRespository()
        self.authRepository = DefaultAuthRepository()
    }
    
    func login(authType: ProviderType) async throws -> (message: String, userId: String) {
        switch authType {
        case .kakao:
            let _ = try await kakaoAuthRepository.isKakaoTalkLoginAvailable()
            let userId = try await kakaoAuthRepository.getUserInformation()
//            let message = try await authRepository.login(memberId: userId)
            return ("비회원 계정입니다.", userId)
        case .apple:
            let userId = try await appleAuthRespository.loginWithApple()
//            let message = try await authRepository.login(memberId: userId)
            print(userId)
            return ("비회원 계정입니다.", userId)
        }
    }
    
    func checkNicknameDuplicate(nickName: String) async throws -> Bool {
       return try await authRepository.checkNickNameDuplicate(nickName)
    }
    
    func getAppleAuthorizationController() -> ASAuthorizationController {
        return appleAuthRespository.authorizationController
    }
    
    func register(signupUerModel: SignupUserModel) async throws -> String {
        // keychain에 token 넣기
        return try await authRepository.register(userRegister: signupUerModel.toData())
    }
    
}
