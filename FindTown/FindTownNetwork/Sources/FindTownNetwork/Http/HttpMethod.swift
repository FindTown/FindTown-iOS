//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case patch
    case delete
    
    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
