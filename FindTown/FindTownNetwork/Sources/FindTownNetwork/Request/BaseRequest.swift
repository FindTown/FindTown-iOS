//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public protocol BaseRequest: Request { }

public extension BaseRequest {
    var baseURL: String {
        return "http://18.182.80.111:8080"
    }
}
