//
//  ResignRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/16.
//

import Foundation
import FindTownNetwork

struct ResignRequest: BaseRequest {
    
    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = MemberResignDTO
    var path: String = "/app/members/resign"
    var method: FindTownNetwork.HttpMethod = .delete
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
