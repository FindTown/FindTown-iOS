//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

struct HTTPHeaders {
    public var headers: [HTTPHeader] = []
    public let name: String
    public let value: String
    
    public init(_ headers: [HTTPHeader]) {
        headers = headers
    }
}
