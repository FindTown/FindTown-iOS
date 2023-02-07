//
//  LogoutRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/05.
//

import Foundation
import FindTownNetwork

struct LogoutRequest: BaseRequest {
    
    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = LogoutResponseDTO
    var path: String = "/app/members/logout"
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}

