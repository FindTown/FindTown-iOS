//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public protocol BaseRequest: Request { }

public extension BaseRequest {
    var baseURL: URL {
        guard let apiURL = URL(string: "http://18.182.80.111:8080") else { fatalError("URL is invalid") }
        return apiURL
    }
}
