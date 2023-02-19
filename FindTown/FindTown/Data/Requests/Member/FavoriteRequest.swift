//
//  FavoriteRequest.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/20.
//

import Foundation
import FindTownNetwork

struct FavoriteRequest: BaseRequest {

    init(HTTPHeaders: HTTPHeaders, parameters: [URLQueryItem]) {
        self.headers = HTTPHeaders
        self.parameters = parameters
    }
    
    typealias ResponseType = FavoriteResponseDTO
    
    var path = "/app/members/wishtown"
    var method: HttpMethod = .post
    var headers: HTTPHeaders
    var task: TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
