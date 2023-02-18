//
//  AuthUseCase.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import AuthenticationServices

import FindTownNetwork

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
    
    func login(authType: ProviderType) async throws {
        switch authType {
        case .kakao:
            let _ = try await kakaoAuthRepository.isKakaoTalkLoginAvailable()
            let userData = try await kakaoAuthRepository.getUserInformation()
            let tokenData = try await authRepository.login(memberId: userData.userId)
            try await tokenRepository.createTokens(tokenData: tokenData)
        case .apple:
            let userData = try await appleAuthRespository.loginWithApple()
            let tokenData = try await authRepository.login(memberId: userData.userId)
            try await tokenRepository.createTokens(tokenData: tokenData)
        }
    }
    
    func getAppleAuthorizationController() -> ASAuthorizationController {
        return appleAuthRespository.authorizationController
    }
    
    func reissue() async throws -> String {
        let (refreshToken, refreshTokenExpiredTime) = try await tokenRepository.readRefreshToken()
        
        if refreshTokenExpiredTime - Date().timeIntervalSince1970 < 600 {
            // 만료
            throw FTNetworkError.unauthorized
        } else {
            // 만료 안됨
            let tokenData = try await authRepository.reissue(refreshToken: refreshToken)
            try await tokenRepository.updateAccessToken(aceessToken: tokenData.accessTokenData.token,
                                                        accesstokenExpiredTime: tokenData.accessTokenData.tokenClaims.exp)
            return tokenData.accessTokenData.token
        }
    }
    
    func getAccessToken() async throws -> String {
        let (accessToken, accessTokenExpiredTime) = try await tokenRepository.readAccessToken()
        if accessTokenExpiredTime - Date().timeIntervalSince1970 < 600 {
            // 만료 시 재발급
            return try await reissue()
        } else {
            // 만료 안됨
            return accessToken
        }
    }
    
    func getUserData() async throws -> SigninUserModel {
        return try await kakaoAuthRepository.getUserInformation()
    }
    
    func memberConfirm(accessToken: String) async throws -> String {
        let userData = try await authRepository.loginConfirm(accessToken: accessToken)
        return userData.loginConfirm.memberId
    }
}
