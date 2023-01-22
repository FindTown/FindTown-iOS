//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import Foundation

final class MockURLSession: URLSessionProtocol {
    
    var makeRequestFail: Bool
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        let request = MockRequest()
        let url = URL(target: request)
        
        // Succeess Response
        let successResonse = HTTPURLResponse(url: url,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        guard let response = successResonse else {
            throw MockError.response
        }
        return (MockData.rawData, response)
    }
}

enum MockError: Error {
    case response
}
