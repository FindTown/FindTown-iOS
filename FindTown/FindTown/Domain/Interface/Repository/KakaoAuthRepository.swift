//
//  KakaoAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol KakaoAuthRepository {
    func isKakaoTalkLoginAvailable() async throws -> String
    func getUserInformation() async throws -> SigninUserModel
}
