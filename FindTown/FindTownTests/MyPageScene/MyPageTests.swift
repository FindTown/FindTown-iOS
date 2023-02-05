//
//  MyPageTests.swift
//  FindTownTests
//
//  Created by 김성훈 on 2023/02/02.
//

import XCTest
@testable import FindTown
@testable import FindTownNetwork

final class MyPageTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_성훈닉네임_중복() async throws {
        // given
        let parameters = [URLQueryItem(name: "nickname", value: "성훈")]
        let request = NickNameCheckRequest(parameters: parameters)
        
        // when
        let response = try await Network.shared.request(target: request, cachePolicy: .useProtocolCachePolicy)
        
        // then
        XCTAssertEqual(response.body.existConfirm, true)
    }
    
    func test_중복일리가없어닉네임_중복아님() async throws {
        // given
        let parameters = [URLQueryItem(name: "nickname", value: "중복일리가없어")]
        let request = NickNameCheckRequest(parameters: parameters)
        
        // when
        let response = try await Network.shared.request(target: request, cachePolicy: .useProtocolCachePolicy)
        
        // then
        XCTAssertEqual(response.body.existConfirm, false)
    }
}
