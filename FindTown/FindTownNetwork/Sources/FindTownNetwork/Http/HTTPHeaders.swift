//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

struct HTTPHeaders {
    public let headers: [HTTPHeader]
    
    public init(_ headers: [HTTPHeader]) {
        self.headers = headers
    }
}
