//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public enum HTTPHeaderField {
    case contentType
    case accept
    case authorization
    case custom(String)
    
    var description: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .accept:
            return "Accept"
        case .authorization:
            return "Authorization"
        case .custom(let headerString):
            return headerString
        }
    }
}
