//
//  ChangeNicknameRequest.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/18.
//

import Foundation
import FindTownNetwork

struct ChangeNicknameRequest: BaseRequest {
    
    init(
        parameters: [URLQueryItem],
        HTTPHeaders: HTTPHeaders
    ) {
        self.parameters = parameters
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = ChangeNicknameResponseDTO
    var path: String = "/app/members/edit/nickname"
    var method: FindTownNetwork.HttpMethod = .put
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]?
}
