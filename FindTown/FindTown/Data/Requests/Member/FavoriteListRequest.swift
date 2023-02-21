//
//  FavoriteListRequest.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/19.
//

import Foundation
import FindTownNetwork

struct FavoriteListRequest: BaseRequest {

    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = FavoriteListResponseDTO
    
    var path = "/app/members/wishtown"
    var method: HttpMethod = .get
    var headers: HTTPHeaders
    var task: TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
