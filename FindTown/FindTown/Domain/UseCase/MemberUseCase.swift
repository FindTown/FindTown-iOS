//
//  UserUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation

final class MemberUseCase {
    
    let memberRepository: DefaultMemberRepository
    let tokenRepository: DefaultTokenRepository
    
    init() {
        self.memberRepository = DefaultMemberRepository()
        self.tokenRepository = DefaultTokenRepository()
    }
    
    func getMemberInfomation(accessToken: String) async throws -> MemberInfomationDTO {
        return try await memberRepository.getMemberInfomation(accessToken)
    }
    
    func checkNicknameDuplicate(nickName: String) async throws -> Bool {
       return try await memberRepository.checkNickNameDuplicate(nickName)
    }
    
    func signup(signupUerModel: SignupUserModel) async throws {
        let tokenData = try await memberRepository.signup(memberSignupDTO: signupUerModel.toData())
        try await tokenRepository.createTokens(tokenData: tokenData)
    }
    
    func logout(accessToken: String) async throws -> Bool {
        return try await memberRepository.logout(accessToken: accessToken).logout
    }
    
    func resign(accessToken: String) async throws -> Bool {
        let isResign = try await memberRepository.resign(accessToken: accessToken).resignMember
        if isResign {
            try await tokenRepository.deleteTokens()
        }
        return isResign
    }
}
