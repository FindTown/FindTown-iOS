//
//  UserInfomationRequest.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

struct MemberInformationRequest: BaseRequest {

    init(HTTPHeaders: HTTPHeaders) {
        self.headers = HTTPHeaders
    }
    
    typealias ResponseType = MemberInformationResponseDTO
    var path: String = "/app/members/info"
    var method: FindTownNetwork.HttpMethod = .get
    var headers: FindTownNetwork.HTTPHeaders
    var task: FindTownNetwork.TaskType = .requestPlain
    var parameters: [URLQueryItem]? = nil
}
