//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

protocol Networkable {
    func request<T: Request>(target: T, cachePolicy: URLRequest.CachePolicy) async throws -> T.Response
}

public class Network: Networkable {
    
    public static let shared = Network()
    
    private let session: Sessionable
    private let decoder: JSONDecoder
    
    private init(session: Session = Session(),
                 decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func request<T: Request>(target: T, cachePolicy: URLRequest.CachePolicy) async throws -> T.Response {
        let url = URL(target: target)
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = target.method.value
        
        for header in target.headers.headers {
            request.setValue(header.value, forHTTPHeaderField: header.name.description)
        }
        
        let responseData: Data
        switch target.task {
        case .requestPlain:
            responseData = try await session.request(request: request)
        case .requestData(let data):
            // 미완성
            request.httpBody = data
            responseData = try await session.request(request: request)
        case .requestJSONEncodable(let encodable):
            // 미완성
            responseData = try await session.request(request: request.encoded(encodable: encodable))
        case .requestCustomJSONEncodable(let encodable, let encoder):
            // 미완성
            responseData = try await session.request(request: request.encoded(encodable: encodable, encoder: encoder))
        }
        
        let bodyData = try decoder.decode(BaseResponse.self, from: responseData).body
        return try decoder.decode(T.Response.self, from: bodyData)
    }
}
