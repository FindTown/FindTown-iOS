//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

protocol BaseRequestType: RequestType { }

extension BaseRequestType {
    var baseURL: URL {
        guard let apiURL = URL(string: "18.182.80.111:8080") else { fatalError("URL is invalid") }
        return apiURL
    }
}
