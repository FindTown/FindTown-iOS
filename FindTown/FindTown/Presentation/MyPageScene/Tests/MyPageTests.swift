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

//@testable import FindTown
//
//var testDelegate: HomeViewModelDelegate!
//
//class HomeViewModelDelegateMock: HomeViewModelDelegate {
//    func goToFilterBottomSheet() { }
//}
//
//final class HomeTest: XCTestCase {
//
//    var viewModel: HomeViewModel!
//
//    override func setUp() {
//        testDelegate = HomeViewModelDelegateMock()
//        viewModel = HomeViewModel(delegate: testDelegate)
//    }
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        XCTAssertEqual(15, Traffic.allCases.count)
//    }
//
//    func testHomeViewModel() throws {
//
//        let searchCategoryModel = ["인프라", "교통", "test"]
//        viewModel.output.searchFilterDataSource.accept(searchCategoryModel)
//
//        let count = viewModel.output.searchFilterDataSource.value.count
//
//        XCTAssertEqual(3, count)
//
//        viewModel.input.resetButtonTrigger.onNext(())
//
//        let count2 = viewModel.output.searchFilterDataSource.value.count
//
//        XCTAssertEqual(2, count2)
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
