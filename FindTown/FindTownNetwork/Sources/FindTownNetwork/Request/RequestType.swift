//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

protocol RequestType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: HTTPHeaders { get }
    var task: Task { get }
}
