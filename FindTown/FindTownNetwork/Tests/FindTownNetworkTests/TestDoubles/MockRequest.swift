//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

@testable import FindTownNetwork
import Foundation

struct MockRequest: Request {
    typealias ResponseType = MockResponse
    
    var baseURL: URL {
        guard let apiURL = URL(string: "http://18.182.80.111:8080") else { fatalError("URL is invalid") }
        return apiURL
    }
    var path: String = "/health"
    var method: HttpMethod = .get
    var headers: HTTPHeaders = HTTPHeaders([.accept("*/*")])
    var task: TaskType = .requestPlain
}
