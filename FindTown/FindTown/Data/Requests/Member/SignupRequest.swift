//
//  RegisterRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation
import FindTownNetwork

struct SignupRequest: BaseRequest {
    
    init(task: FindTownNetwork.TaskType) {
        self.task = task
    }
    
    typealias ResponseType = TokenInformationDTO
    var path: String = "/app/members/signup"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                                            .contentType("application/json")])
    var task: FindTownNetwork.TaskType
    var parameters: [URLQueryItem]? = nil
}
