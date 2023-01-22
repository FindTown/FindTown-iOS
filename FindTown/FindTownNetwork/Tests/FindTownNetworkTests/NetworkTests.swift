//
//  NetworkTests.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import XCTest

final class NetworkTests: XCTestCase {

    var network: Network!
    
    var mockSession: MockSession!
    var mockRequest: MockRequest!
    
    override func setUpWithError() throws {
        mockSession = MockSession()
        mockRequest = MockRequest()
        
        network = Network(session: mockSession)
    }

    override func tearDownWithError() throws {
        mockSession = nil
        mockRequest = nil
        network = nil
    }

    func test_request메서드_성공() async throws {
        // given
        mockSession.makeRequestFail = false
        
        // when
        let data = try await network.request(target: mockRequest)

        // then
        XCTAssertEqual(data.test, "test")
    }
    
    func test_request메서드_실패() async throws {
        // given
        mockSession.makeRequestFail = true
        
        // when
        do {
            let data = try await network.request(target: mockRequest)
        } catch {
            // then
            XCTAssertEqual(error as! MockError, MockError.response)
        }
    }
}
