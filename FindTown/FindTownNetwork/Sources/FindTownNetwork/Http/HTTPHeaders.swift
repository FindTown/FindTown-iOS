//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public struct HTTPHeaders {
    internal let headers: [HTTPHeader]
    
    public init(_ headers: [HTTPHeader]) {
        self.headers = headers
    }
}
