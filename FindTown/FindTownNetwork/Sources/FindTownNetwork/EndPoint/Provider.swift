//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

class Provider<Request: RequestType> {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func request(target: Request, cachePolicy: URLRequest.CachePolicy) async throws -> Data {
        let url = URL(target: target)
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = target.method.value
        
        for header in target.headers.headers {
            request.setValue(header.value, forHTTPHeaderField: header.name.description)
        }
        
        switch target.task {
        case .requestPlain:
            return try await session.request(request: request)
        case .requestData(let data):
            request.httpBody = data
            return try await session.request(request: request)
        case .requestJSONEncodable(let encodable):
            return try await session.request(request: request.encoded(encodable: encodable))
        case .requestCustomJSONEncodable(let encodable, let encoder):
            return try await session.request(request: request.encoded(encodable: encodable, encoder: encoder))
        }
    }
}
