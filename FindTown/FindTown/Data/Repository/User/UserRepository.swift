//
//  UserRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

final class UserRepository {

    func getUserInfomation(_ bearerToken: String) async throws -> String {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                         .authorization(bearerToken: bearerToken)])
        let data = try await Network.shared.request(target: UserInfomationRequest(HTTPHeaders: HTTPHeaders))
        return data.body.userInfo.nickname
    }
}
