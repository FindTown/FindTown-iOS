//
//  DefaultAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import FindTownNetwork

final class DefaultAuthRepository {
    
    func login(memberId: String) async throws -> TokenInformationDTO {
        let memberInformation = MemberInformationDTO(memberId: memberId)
        let data = try await Network.shared.request(target: AuthLoginReqeust(task: .requestJSONEncodable(encodable: memberInformation)))
        return data.body
    }
    
    func checkNickNameDuplicate(_ nickName: String) async throws -> Bool {
        let parameters = [URLQueryItem(name: "nickname", value: nickName)]
        let data = try await Network.shared.request(target: NickNameCheckRequest(parameters: parameters))
        return data.body.existConfirm
    }
    
    func signup(memberSignupDTO: MemberSignupDTO) async throws -> TokenInformationDTO {
        let data = try await Network.shared.request(target: SignupRequest(task: .requestJSONEncodable(encodable: memberSignupDTO)))
        return data.body
    }
    
    func reissue(accessToken: String) async throws -> ReissueResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: ReissueRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func loginConfirm(accessToken: String) async throws -> LoginConfirmReponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: LoginConfirmRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func logout(accessToken: String) async throws -> LogoutResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: LogoutRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
}
