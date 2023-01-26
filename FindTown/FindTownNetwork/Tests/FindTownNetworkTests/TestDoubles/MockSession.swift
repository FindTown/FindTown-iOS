//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import Foundation

class MockSession: Sessionable {

    var makeRequestFail = false
    
    func request(request: URLRequest) async throws -> Data {
        
        if makeRequestFail {
            throw MockError.response
        } else {
            return MockData.rawData
        }
    }
}
