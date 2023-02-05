//
//  DefaultTokenRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/03.
//

import Foundation

import FindTownNetwork

final class DefaultTokenRepository {
    
    func createTokens(tokenData: TokenInformationDTO) async throws {
        try KeyChainManager.shared.create(account: .accessToken, data: tokenData.accessToken)
        try KeyChainManager.shared.create(account: .accesstokenExpiredTime, data: String(tokenData.accessTokenExpiredTime))
        try KeyChainManager.shared.create(account: .refreshToken, data: tokenData.refreshToken)
        try KeyChainManager.shared.create(account: .refreshTokenExpiredTime, data: String(tokenData.refreshTokenExpiredTime))
    }
    
    func updateAccessToken(aceessToken: String, accesstokenExpiredTime: TimeInterval) async throws {
        try KeyChainManager.shared.create(account: .accessToken, data: aceessToken)
        try KeyChainManager.shared.create(account: .accesstokenExpiredTime, data: String(accesstokenExpiredTime))
    }
    
    func readAccessToken() async throws -> (String, TimeInterval) {
        let accessToken = try KeyChainManager.shared.read(account: .accessToken)
        let accessTokenExpiredTimeString = try KeyChainManager.shared.read(account: .accesstokenExpiredTime)
        
        let accessTokenExpiredTime = try Double(accessTokenExpiredTimeString, format: .number)
        return (accessToken, accessTokenExpiredTime)
    }
    
    func readRefreshToken() async throws -> (String, TimeInterval) {
        let refreshToken = try KeyChainManager.shared.read(account: .refreshToken)
        let refreshTokenExpiredTimeString = try KeyChainManager.shared.read(account: .refreshTokenExpiredTime)
        
        let refreshTokenExpiredTime = try Double(refreshTokenExpiredTimeString, format: .number)
        return (refreshToken, refreshTokenExpiredTime)
    }
    
    func deleteTokens() async throws {
        try KeyChainManager.shared.delete(account: .accessToken)
        try KeyChainManager.shared.delete(account: .accesstokenExpiredTime)
        try KeyChainManager.shared.delete(account: .refreshToken)
        try KeyChainManager.shared.delete(account: .refreshTokenExpiredTime)
    }
}
