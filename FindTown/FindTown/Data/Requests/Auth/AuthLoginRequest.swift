//
//  AuthLoginRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import FindTownNetwork

struct AuthLoginReqeust: BaseRequest {
    
    init(task: FindTownNetwork.TaskType) {
        self.task = task
    }
    
    typealias ResponseType = LoginResponseDTO
    var path: String = "/auth/login"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                                            .contentType("application/json")])
    var task: FindTownNetwork.TaskType
    var parameters: [URLQueryItem]? = nil
}
