//
//  ReissueRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/03.
//

import Foundation
import FindTownNetwork

struct ReissueRequest: BaseRequest {
    
    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = ReissueResponseDTO
    var path: String = "/auth/reissue/token"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
