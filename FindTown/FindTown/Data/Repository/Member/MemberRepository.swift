//
//  UserRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

final class MemberRepository {
    
    func getMemberInformation(_ accessToken: String) async throws -> MemberInformationDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: MemberInformationRequest(HTTPHeaders: HTTPHeaders))
        return data.body.memberInformation
    }
}
