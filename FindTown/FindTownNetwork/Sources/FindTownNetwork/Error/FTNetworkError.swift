//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public enum FTNetworkError: LocalizedError, Equatable {
    case invaildServerResponse
    case client(errorCode: Int)
    case server(errorCode: Int)
    
    case unauthorized
    case noData
    case decode
    case encode
    case url
    
    case kakao
    case apple
    
    public static func isUnauthorized(error: FTNetworkError) -> Bool {
        if case error = FTNetworkError.unauthorized {
            return true
        } else {
            return false
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .invaildServerResponse:
            return "유효하지 않은 에러"
        case .client(let errorCode):
            return "클라이언트 에러 : \(errorCode)"
        case .server(let errorCode):
            return "서버 에러 : \(errorCode)"
        case .unauthorized:
            return "유효하지 않은 사용자"
        case .noData:
            return "값이 없음"
        case .decode:
            return "디코딩 에러"
        case .encode:
            return "인코딩 에러"
        case .url:
            return "url 에러"
        case .kakao:
            return "kakao auth 에러"
        case .apple:
            return "apple auth 에러"
        }
    }
}
