//
//  TokenRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol TokenRepository {
    func createTokens(tokenData: TokenData) async throws
    func updateAccessToken(aceessToken: String, accesstokenExpiredTime: TimeInterval) async throws
    func readAccessToken() async throws -> (String, TimeInterval)
    func readRefreshToken() async throws -> (String, TimeInterval)
    func deleteTokens() async throws
}
