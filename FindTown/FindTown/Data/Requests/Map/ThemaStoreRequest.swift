//
//  ThemaStoreRequest.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/17.
//

import Foundation
import FindTownNetwork

struct ThemaStoreRequest: BaseRequest {

    init(path: String) {
        self.path = path
    }
    
    typealias ResponseType = MapThemaStoreResponseDTO
    var path: String
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders = HTTPHeaders([.accept("*/*")])
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
