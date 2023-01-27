//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation
import FindTownCore

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
        
        switch target.task {
        case .requestPlain:
            break
        case .requestData(let data):
            request.httpBody = data
        case .requestJSONEncodable(let encodable):
            request = try request.encoded(encodable: encodable)
        }
        
        let responseData = try await session.request(request: request)
        let data = try responseData.decode(BaseResponse<T.ResponseType>.self)
        
        return data
    }
}
