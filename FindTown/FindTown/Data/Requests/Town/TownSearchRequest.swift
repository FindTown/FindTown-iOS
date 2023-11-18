//
//  TownSearchRequest.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/18.
//

import Foundation
import FindTownNetwork

struct TownSearchRequest: BaseRequest {
    
    init(path: String, parameters: [URLQueryItem], headers: HTTPHeaders) {
        self.path = path
        self.parameters = parameters
        self.headers = headers
    }
    
    typealias ResponseType = TownSearchResponseDTO
    var path: String
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
