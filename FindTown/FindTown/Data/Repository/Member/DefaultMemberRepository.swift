//
//  UserRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

final class DefaultMemberRepository {
    
    func checkNickNameDuplicate(_ nickName: String) async throws -> Bool {
        let parameters = [URLQueryItem(name: "nickname", value: nickName)]
        let data = try await Network.shared.request(target: NickNameCheckRequest(parameters: parameters))
        return data.body.existConfirm
    }
    
    func changeNickname(nickName: String, accessToken: String) async throws -> Bool {
        let parameters = [URLQueryItem(name: "nickname", value: nickName)]
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: ChangeNicknameRequest(parameters: parameters,
                                                                                  HTTPHeaders: HTTPHeaders))
        return data.body.editSuccess
    }
    
    func signup(memberSignupDTO: MemberSignupDTO) async throws -> TokenInformationDTO {
        let data = try await Network.shared.request(target: SignupRequest(task: .requestJSONEncodable(encodable: memberSignupDTO)))
        return data.body
    }
    
    func getMemberInformation(_ accessToken: String) async throws -> MemberInformationDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: MemberInformationRequest(HTTPHeaders: HTTPHeaders))
        return data.body.memberInfomation
    }
    
    func logout(accessToken: String) async throws -> LogoutResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: LogoutRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func resign(accessToken: String) async throws -> MemberResignDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let data = try await Network.shared.request(target: ResignRequest(HTTPHeaders: HTTPHeaders))
        return data.body
    }
}
