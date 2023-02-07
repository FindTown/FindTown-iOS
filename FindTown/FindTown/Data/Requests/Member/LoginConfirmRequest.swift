//
//  LoginConfirmRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct LoginConfirmRequest: BaseRequest {
    
    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = LoginConfirmReponseDTO
    var path: String = "/auth/login/confirm"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
