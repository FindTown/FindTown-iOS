//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public protocol Request {
    associatedtype ResponseType: Response
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: HTTPHeaders { get }
    var task: TaskType { get }
    var parameters: [URLQueryItem]? { get }
}
