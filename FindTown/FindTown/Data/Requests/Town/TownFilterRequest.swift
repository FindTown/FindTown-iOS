//
//  FilterRequest.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation
import FindTownNetwork

struct TownFilterRequest: BaseRequest {
    
    init(
        task: FindTownNetwork.TaskType,
        HTTPHeaders: HTTPHeaders
    ) {
        self.task = task
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = TownFilterResponseDTO
    var path: String = "/app/town/filter"
    var method: FindTownNetwork.HttpMethod = .post
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType
    var parameters: [URLQueryItem]? = nil
}
