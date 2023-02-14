//
//  UserUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation

final class MemberUseCase {
    
    let memberRepository: MemberRepository
    let tokenRepository: DefaultTokenRepository
    
    init() {
        self.memberRepository = MemberRepository()
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
}
