//
//  RegisterRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation
import FindTownNetwork

struct RegisterRequest: BaseRequest {
    
    init(task: FindTownNetwork.TaskType) {
        self.task = task
    }
    
    // 임시
    typealias ResponseType = BodyNull
    var path: String = "/auth/register"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                                            .contentType("application/json")])
    var task: FindTownNetwork.TaskType
    var parameters: [URLQueryItem]? = nil
}
