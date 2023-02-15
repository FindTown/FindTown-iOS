//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public struct HTTPHeader {
    internal let name: HTTPHeaderField
    internal let value: String
    
    public init(name: HTTPHeaderField, value: String) {
        self.name = name
        self.value = value
    }
    
    public static func accept(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: .accept, value: value)
    }
    
    public static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: .contentType, value: value)
    }
    
    public static func authorization(bearerToken: String) -> HTTPHeader {
        return HTTPHeader(name: .authorization, value: "Bearer \(bearerToken)")
    }
    
    public static func custom(headerString: String, _ value: String) -> HTTPHeader {
        return HTTPHeader(name: .custom(headerString), value: value)
    }

}
