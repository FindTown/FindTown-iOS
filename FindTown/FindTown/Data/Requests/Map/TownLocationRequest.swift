//
//  TownLocationRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation
import FindTownNetwork

struct TownLocationRequest: BaseRequest {

    init(HTTPHeaders: HTTPHeaders, parameters: [URLQueryItem]?) {
        self.headers = HTTPHeaders
        self.parameters = parameters
    }
    
    typealias ResponseType = TownMapLocationDTO
    var path: String = "/app/townMap/location"
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
