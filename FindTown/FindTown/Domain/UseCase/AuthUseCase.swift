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
    let tokenRepository: DefaultTokenRepository
    
    init() {
        self.kakaoAuthRepository = DefaultKakaoAuthRepository()
        self.appleAuthRespository = DefaultAppleAuthRespository()
        self.authRepository = DefaultAuthRepository()
        self.tokenRepository = DefaultTokenRepository()
    }
    
    func login(authType: ProviderType) async throws -> (message: String, userId: SigninUserModel) {
        switch authType {
        case .kakao:
            let _ = try await kakaoAuthRepository.isKakaoTalkLoginAvailable()
            let userData = try await kakaoAuthRepository.getUserInformation()
            print(userData.userId)
            let message = try await authRepository.login(memberId: userData.userId)
            return (message, userData)
        case .apple:
            let userData = try await appleAuthRespository.loginWithApple()
            let message = try await authRepository.login(memberId: userData.userId)
            return (message, userData)
        }
    }
    
    func checkNicknameDuplicate(nickName: String) async throws -> Bool {
       return try await authRepository.checkNickNameDuplicate(nickName)
    }
    
    func getAppleAuthorizationController() -> ASAuthorizationController {
        return appleAuthRespository.authorizationController
    }
    
    func signup(signupUerModel: SignupUserModel) async throws {
        let tokenData = try await authRepository.signup(memberSignupDTO: signupUerModel.toData())
        try await tokenRepository.createTokens(tokenData: tokenData)
    }
    
    func reissue() async throws -> String {
        let (refreshToken, refreshTokenExpiredTime) = try await tokenRepository.readAccessToken()
        
        if refreshTokenExpiredTime < Date() {
            
        } else {
            return ""
        }
    }
    
    func getTokenData() async throws -> String {
        let (accessToken, accessTokenExpiredTime) = try await tokenRepository.readAccessToken()
        if accessTokenExpiredTime < Date() {
            return accessToken
        } else {
            reissue()
            return ""
        }
    }
    
}
