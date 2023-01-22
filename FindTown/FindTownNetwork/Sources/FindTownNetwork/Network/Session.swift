//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

protocol Sessionable {
    func request(request: URLRequest) async throws -> Data
}

class Session: Sessionable {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request(request: URLRequest) async throws -> Data {
        let (data, response) = try await self.session.data(for: request, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invaildServerResponse
        }
        
        if 401 == httpResponse.statusCode {
            throw NetworkError.unauthorized
        }
        if 400..<500 ~= httpResponse.statusCode {
            throw NetworkError.client
        }
        
        if 500..<600 ~= httpResponse.statusCode {
            throw NetworkError.server
        }
        return data
    }
}
