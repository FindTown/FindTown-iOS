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
        try KeyChainManager.shared.create(account: .accesstokenExpiredTime, data: tokenData.accessTokenExpiredTime)
        try KeyChainManager.shared.create(account: .refreshToken, data: tokenData.refreshToken)
        try KeyChainManager.shared.create(account: .refreshTokenExpiredTime, data: tokenData.refreshTokenExpiredTime)
    }
    
    func readAccessToken() async throws -> (String, Date) {
        let accessToken = try KeyChainManager.shared.read(account: .accessToken)
        let accessTokenExpiredTime = try KeyChainManager.shared.read(account: .accesstokenExpiredTime)
        
        guard let accessToken = accessToken as? String,
              let accessTokenExpiredTime = accessTokenExpiredTime as? Date else {
            throw FTNetworkError.noData
        }
        return (accessToken, accessTokenExpiredTime)
    }
    
    func readRefreshToken() async throws -> (String, Date) {
        let refreshToken = try KeyChainManager.shared.read(account: .refreshToken)
        let refreshTokenExpiredTime = try KeyChainManager.shared.read(account: .refreshTokenExpiredTime)
        
        guard let refreshToken = refreshToken as? String,
              let refreshTokenExpiredTime = refreshTokenExpiredTime as? Date else {
            throw FTNetworkError.noData
        }
        return (refreshToken, refreshTokenExpiredTime)
    }
    
    func deleteTokens() async throws {
        try KeyChainManager.shared.delete(account: .accessToken)
        try KeyChainManager.shared.delete(account: .accesstokenExpiredTime)
        try KeyChainManager.shared.delete(account: .refreshToken)
        try KeyChainManager.shared.delete(account: .refreshTokenExpiredTime)
    }
}


