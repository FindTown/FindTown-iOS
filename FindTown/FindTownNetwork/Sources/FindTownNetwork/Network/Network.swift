//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

protocol Networkable {
    func request<T: Request>(target: T,
                             cachePolicy: URLRequest.CachePolicy) async throws -> BaseResponse<T.ResponseType>
}

public class Network: Networkable {
    
    public static let shared = Network()
    
    private let session: Sessionable
    private let decoder: JSONDecoder
    
    internal init(session: Sessionable = Session(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func request<T: Request>(target: T,
                                    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) async throws -> BaseResponse<T.ResponseType> {
        
        let url: URL
        if let queryParameters = target.parameters {
            var component = URLComponents(target: target)
            component.queryItems = queryParameters
            guard let componentUrl = component.url else { throw FTNetworkError.url }
            url = componentUrl
        } else {
            url = URL(target: target)
        }
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
        }
        
        let data = try responseData.decode(BaseResponse<T.ResponseType>.self)
        
        return data
    }
}
