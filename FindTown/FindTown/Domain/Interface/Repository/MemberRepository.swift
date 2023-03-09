//
//  MemberRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol MemberRepository {
    func checkNickNameDuplicate(_ nickName: String) async throws -> Bool
    func changeNickname(nickName: String, accessToken: String) async throws -> Bool
    func signup(memberSignupDTO: MemberSignupDTO) async throws -> TokenInformationDTO
    func getMemberInformation(_ accessToken: String) async throws -> MemberInformationDTO
    func logout(accessToken: String) async throws -> LogoutResponseDTO
    func resign(accessToken: String) async throws -> MemberResignDTO
    func getFavoriteList(accessToken: String) async throws -> FavoriteListResponseDTO
    func favorite(accessToken: String, cityCode: Int) async throws -> FavoriteResponseDTO
}
