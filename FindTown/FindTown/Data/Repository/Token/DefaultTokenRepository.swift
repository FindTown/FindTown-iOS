//
//  DefaultTokenRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/03.
//

import Foundation
import FindTownNetwork

final class DefaultTokenRepository: TokenRepository {
    
    func createTokens(tokenData: TokenData) async throws {
        try KeyChainManager.shared.create(account: .accessToken, data: tokenData.accessToken)
        let accessTokenExpiredTime = try await extractExpiredTime(token: tokenData.accessToken)
        try KeyChainManager.shared.create(account: .accesstokenExpiredTime, data: String(accessTokenExpiredTime))
        try KeyChainManager.shared.create(account: .refreshToken, data: tokenData.refreshToken)
        let refreshTokenExpiredTime = try await extractExpiredTime(token: tokenData.refreshToken)
        try KeyChainManager.shared.create(account: .refreshTokenExpiredTime, data: String(refreshTokenExpiredTime))
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
    
    func extractExpiredTime(token: String) async throws -> TimeInterval {
        let tokenString = token.components(separatedBy: ".")
        let toDecode = tokenString[1] as String

        var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
        stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
        switch (stringtoDecode.utf16.count % 4) {
        case 2: stringtoDecode = "\(stringtoDecode)=="
        case 3: stringtoDecode = "\(stringtoDecode)="
        default: // nothing to do stringtoDecode can stay the same
            print("")
        }
        let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
        let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)

        guard let string = base64DecodedString,
              let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) else {
            throw FTNetworkError.decode
        }
        
        let tokenClaims = try JSONDecoder().decode(TokenPayloadDTO.self, from: data)
        return tokenClaims.exp
    }
}
