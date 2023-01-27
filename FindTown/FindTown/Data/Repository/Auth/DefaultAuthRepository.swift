//
//  DefaultAuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation
import FindTownNetwork

final class DefaultAuthRepository {
    
    func login(memberId: String) async throws -> String {
        let memberInformation = MemberInformation(memberId: memberId)
        let data = try await Network.shared.request(target: AuthLoginReqeust(task: .requestJSONEncodable(encodable: memberInformation)))
        return data.header.message
    }
    
    func checkNickNameDuplicate(_ nickName: String) async throws -> Bool {
        let parameters = [URLQueryItem(name: "nickname", value: nickName)]
        let data = try await Network.shared.request(target: NickNameCheckRequest(parameters: parameters))
        return data.body.existConfirm.existence
    }
    
    func register(userRegister: UserRegisterDTO) async throws -> String {
        let data = try await Network.shared.request(target: RegisterRequest(task: .requestJSONEncodable(encodable: userRegister)))
        return data.header.message
    }
}
