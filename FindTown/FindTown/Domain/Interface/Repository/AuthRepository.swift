//
//  AuthRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol AuthRepository {
    func login(memberId: String) async throws -> LoginResponseDTO
    func reissue(refreshToken: String) async throws -> ReissueResponseDTO
    func loginConfirm(accessToken: String) async throws -> LoginConfirmReponseDTO
}
