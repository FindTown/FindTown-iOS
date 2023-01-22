//
//  SessionTests.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import XCTest

final class SessionTests: XCTestCase {

    var makeRequestFail = false
    
    var session: Sessionable!
    
    var mockRequest: MockRequest!
    var mockURLSession: URLSessionProtocol!

    override func tearDownWithError() throws {
        mockURLSession = nil
        mockRequest = nil
        session = nil
    }
    
    func test_request메서드_성공() async throws {
        // given
        mockURLSession = MockURLSession(makeRequestFail: false)
        mockRequest = MockRequest()
        
        session = Session(session: mockURLSession)
        
        let url = URL(target: mockRequest)
        let httpRequest = URLRequest(url: url)
        
        do {
            // when
            let data = try await session.request(request: httpRequest)
            
            // then
            XCTAssertEqual(data, MockData.rawData)
        } catch {
            XCTFail()
        }
    }
    
    func test_request메서드_실패() async throws {
        // given
        mockURLSession = MockURLSession(makeRequestFail: true)
        mockRequest = MockRequest()
        
        session = Session(session: mockURLSession)
        
        let url = URL(target: mockRequest)
        let httpRequest = URLRequest(url: url)
        
        do {
            // when
            let data = try await session.request(request: httpRequest)
        } catch {
            // then
            let expectation = MockError.response
            XCTAssertEqual(error as! MockError, expectation)
        }
    }

}
