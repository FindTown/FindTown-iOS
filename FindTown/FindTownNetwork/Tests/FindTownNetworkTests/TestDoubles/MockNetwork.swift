//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import Foundation

class MockNetwork: Networkable {
    
    var makeRequestFail = false
    
    func request<T>(target: T, cachePolicy: URLRequest.CachePolicy) async throws -> T.ResponseType where T : FindTownNetwork.Request {
        
        if makeRequestFail {
            throw MockError.response
        } else {
            return MockResponse(test: "test") as! T.ResponseType
        }
    }
    
}
