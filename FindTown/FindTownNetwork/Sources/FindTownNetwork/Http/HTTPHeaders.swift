//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public struct HTTPHeaders {
    let headers: [HTTPHeader]
    
    init(_ headers: [HTTPHeader]) {
        self.headers = headers
    }
}
