//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public struct HTTPHeader {
    let name: HTTPHeaderField
    let value: String
    
    init(name: HTTPHeaderField, value: String) {
        self.name = name
        self.value = value
    }
    
    static func accept(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: .accept, value: value)
    }
    
    static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: .contentType, value: value)
    }
    
    static func authorization(bearerToken: String) -> HTTPHeader {
        return HTTPHeader(name: .authorization, value: "Berear \(bearerToken)")
    }

}
