//
//  NickNameCheckRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/26.
//

import Foundation
import FindTownNetwork

struct NickNameCheckRequest: BaseRequest {
    
    init(parameters: [URLQueryItem]) {
        self.parameters = parameters
    }
    
    typealias ResponseType = NickCheckResponse
    var path: String = "/app/members/check/nickname"
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders = HTTPHeaders([.accept("*/*")])
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
