//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

enum NetworkError: Error {
    case invaildServerResponse
    case noData
    case decode
    case encode
    case url
}
