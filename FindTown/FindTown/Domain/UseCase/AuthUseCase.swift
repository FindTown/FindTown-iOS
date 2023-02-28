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
    
    init(kakaoAuthRepository: DefaultKakaoAuthRepository,
         appleAuthRespository: DefaultAppleAuthRespository,
         authRepository: DefaultAuthRepository,
         tokenRepository: DefaultTokenRepository
    ) {
        self.kakaoAuthRepository = kakaoAuthRepository
        self.appleAuthRespository = appleAuthRespository
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }
    
    func login(authType: ProviderType) async throws -> (isSuccess: Bool, signinUserModel: SigninUserModel) {
        switch authType {
        case .kakao:
            let _ = try await kakaoAuthRepository.isKakaoTalkLoginAvailable()
            let userData = try await kakaoAuthRepository.getUserInformation()
            let loginResult = try await authRepository.login(memberId: userData.userId)
            if loginResult.loginStatus {
                let tokenData = TokenData(accessToken: loginResult.accessToken, refreshToken: loginResult.refreshToken)
                try await tokenRepository.createTokens(tokenData: tokenData)
            }
            return (loginResult.loginStatus, userData)
        case .apple:
            let userData = try await appleAuthRespository.loginWithApple()
            let loginResult = try await authRepository.login(memberId: userData.userId)
            if loginResult.loginStatus {
                let tokenData = TokenData(accessToken: loginResult.accessToken, refreshToken: loginResult.refreshToken)
                try await tokenRepository.createTokens(tokenData: tokenData)
            }
            return (loginResult.loginStatus, userData)
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
    
    func getUserData(providerType: ProviderType) async throws -> SigninUserModel {
        switch providerType {
        case .kakao:
            return try await kakaoAuthRepository.getUserInformation()
        case .apple:
            return try await appleAuthRespository.loginWithApple()
        }
    }
    
    func memberConfirm(accessToken: String) async throws -> String {
        let userData = try await authRepository.loginConfirm(accessToken: accessToken)
        return userData.loginConfirm.memberId
    }
}
