//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public enum FTNetworkError: Error {
    case invaildServerResponse
    case client
    case server
    
    case unauthorized
    case noData
    case decode
    case encode
    case url
    
    case kakao
    case apple
}
