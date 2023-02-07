//
//  DefaultKakaoAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

final class DefaultKakaoAuthRepository {
    
    /// 추후 개선
    /// 카카오톡 어플이 설치되어있는지 확인하는 로직
    func isKakaoTalkLoginAvailable() async throws -> String {
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: authToken.accessToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: authToken.accessToken)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UserInformation

extension DefaultKakaoAuthRepository {

    /// 카카오톡 유저 id를 반환합니다.
    func getUserInformation() async throws -> SigninUserModel {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else {
                    guard let userId = user?.id else {
                        return
                    }
                    
                    let signinUsermodel = SigninUserModel(userId: String(userId), email: user?.kakaoAccount?.email)
                    continuation.resume(returning: signinUsermodel)
                }
            }
        }
    }
}

