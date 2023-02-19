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
    
    func getMemberInformation(accessToken: String) async throws -> MemberInformationDTO {
        return try await memberRepository.getMemberInformation(accessToken)
    }
    
    func checkNicknameDuplicate(nickName: String) async throws -> Bool {
        return try await memberRepository.checkNickNameDuplicate(nickName)
    }
    
    func changeNickname(nickName: String, accessToken: String) async throws -> Bool {
        return try await memberRepository.changeNickname(nickName: nickName, accessToken: accessToken)
    }
    
    func signup(signupUerModel: SignupUserModel) async throws {
        let tokenData = try await memberRepository.signup(memberSignupDTO: signupUerModel.toData())
        try await tokenRepository.createTokens(tokenData: tokenData)
    }
    
    func logout(accessToken: String) async throws -> Bool {
        let islogout = try await memberRepository.logout(accessToken: accessToken).logout
        if islogout {
            try await tokenRepository.deleteTokens()
        }
        return islogout
    }
    
    func resign(accessToken: String) async throws -> Bool {
        let isResign = try await memberRepository.resign(accessToken: accessToken).resignMember
        if isResign {
            try await tokenRepository.deleteTokens()
        }
        return isResign
    }
}
