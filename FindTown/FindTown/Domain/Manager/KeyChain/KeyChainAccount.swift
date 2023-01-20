//
//  KeyChainAccount.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/12.
//

import Foundation

enum KeyChainAccount {
    case accessToken
    case accesstokenExpiredTime
    case refreshToken
    case refreshTokenExpiredTime
    
    // 더 필요한 Account 추가
    
    var description: String {
        return String(describing: self)
    }
    
    var keyChainClass: CFString {
        switch self {
        case .accessToken:
            return kSecClassGenericPassword
        case .accesstokenExpiredTime:
            return kSecClassGenericPassword
        case .refreshToken:
            return kSecClassGenericPassword
        case .refreshTokenExpiredTime:
            return kSecClassGenericPassword
        }
    }
}
