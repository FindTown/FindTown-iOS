//
//  DefaultAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import FindTownNetwork

final class DefaultAuthRepository {
    
    func login(memberId: String) async throws {
        let memberInformation = MemberInformation(memberId: memberId)
        let data = try await Network.shared.request(target: AuthLoginReqeust(task: .requestJSONEncodable(encodable: memberInformation)))
        print(data.header.code, data.header.message)
    }
}
