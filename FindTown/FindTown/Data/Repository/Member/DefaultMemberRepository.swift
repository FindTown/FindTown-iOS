//
//  UserRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation
import FindTownNetwork

final class DefaultMemberRepository: MemberRepository {
    
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
    
    // 찜 목록 조회
    func getFavoriteList(accessToken: String) async throws -> FavoriteListResponseDTO {
        let httpHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        
        let data = try await Network.shared.request(target: FavoriteListRequest(HTTPHeaders: httpHeaders))
        
        return data.body
    }
    
    // 찜 등록, 해제
    func favorite(accessToken: String, cityCode: Int) async throws -> FavoriteResponseDTO {
        let httpHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let parameters = [URLQueryItem(name: "object_id", value: String(cityCode))]
        
        let data = try await Network.shared.request(target: FavoriteRequest(HTTPHeaders: httpHeaders,
                                                                            parameters: parameters))
        return data.body
    }
}
