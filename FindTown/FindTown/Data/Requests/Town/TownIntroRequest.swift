//
//  TownIntroRequest.swift
//  FindTown
//
//  Created by 장선영 on 2023/02/17.
//

import Foundation
import FindTownNetwork

struct TownIntroRequest: BaseRequest {    
    
    init(HTTPHeaders: HTTPHeaders, parameters: [URLQueryItem]) {
        self.headers = HTTPHeaders
        self.parameters = parameters
    }
    
    typealias ResponseType = TownIntroResponseDTO
    
    var path: String = "/app/town/introduce"
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
