//
//  TownSearchRequest.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/18.
//

import Foundation
import FindTownNetwork

struct TownSearchRequest: BaseRequest {
    
    init(
        task: FindTownNetwork.TaskType,
        HTTPHeaders: HTTPHeaders
    ) {
        self.task = task
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = TownSearchResponseDTO
    var path: String = "/app/town/search"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType
    var parameters: [URLQueryItem]? = nil
}
