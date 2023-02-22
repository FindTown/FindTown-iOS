//
//  DefaultAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import FindTownNetwork

final class DefaultAuthRepository {
    
    func login(memberId: String) async throws -> LoginResponseDTO {
        let memberInformation = MemberIdDTO(memberId: memberId)
        let data = try await Network.shared.request(target: AuthLoginReqeust(task: .requestJSONEncodable(encodable: memberInformation)))
        return data.body
    }
    
    func reissue(refreshToken: String) async throws -> ReissueResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .custom(headerString: "refresh_token", refreshToken)])
        let data = try await Network.shared.request(target: ReissueRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func loginConfirm(accessToken: String) async throws -> LoginConfirmReponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: LoginConfirmRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
}
