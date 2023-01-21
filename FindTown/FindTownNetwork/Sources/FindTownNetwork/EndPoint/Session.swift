//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

class Session {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func request(request: URLRequest) async throws -> Data {
        let (data, response) = try await self.session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invaildServerResponse
        }
        return data
    }
}
