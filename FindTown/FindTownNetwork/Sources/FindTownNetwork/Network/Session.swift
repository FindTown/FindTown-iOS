//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation
import FindTownCore

protocol Sessionable {
    func request(request: URLRequest) async throws -> Data
}

class Session: Sessionable {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request(request: URLRequest) async throws -> Data {
        self.log(request: request)
        let (data, response) = try await self.session.data(for: request, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FTNetworkError.invaildServerResponse
        }
        self.log(response: httpResponse)
        
        if 401 == httpResponse.statusCode {
            throw FTNetworkError.unauthorized
        }
        if 400..<500 ~= httpResponse.statusCode {
            throw FTNetworkError.client
        }
        
        if 500..<600 ~= httpResponse.statusCode {
            throw FTNetworkError.server
        }
        return data
    }
    
    func log(request: URLRequest) {
        Log.debug("reqeust 👇", ["url : \(String(describing: request.url))",
                                   "method : \(String(describing: request.httpMethod))",
                                   "header : \(String(describing: request.allHTTPHeaderFields))"])
    }
    
    func log(response: HTTPURLResponse) {
        Log.debug("reponse 👇", ["statusCode : \(String(describing: response.statusCode ))",
                                 "description : \(String(describing: response.description ))"])
    }
}
