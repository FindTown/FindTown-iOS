//
//  UserUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//
import Foundation

protocol MemberUseCase {
    func getMemberInformation(accessToken: String) async throws -> MemberInformationDTO
    func checkNicknameDuplicate(nickName: String) async throws -> Bool
    func changeNickname(nickName: String, accessToken: String) async throws -> Bool
    func signup(signupUerModel: SignupUserModel) async throws
    func logout(accessToken: String) async throws -> Bool
    func resign(accessToken: String) async throws -> Bool
    func getFavoriteList(accessToken: String) async throws -> [TownTableModel]
    func favorite(accessToken: String, cityCode: Int) async throws -> Bool
}

final class DefaultMemberUseCase: MemberUseCase {
    
    let memberRepository: MemberRepository
    let tokenRepository: TokenRepository
    
    init(memberRepository: MemberRepository,
         tokenRepository: TokenRepository
    ) {
        self.memberRepository = memberRepository
        self.tokenRepository = tokenRepository
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
        try await tokenRepository.createTokens(tokenData: tokenData.toEntity())
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
    
    // 찜 목록
    func getFavoriteList(accessToken: String) async throws -> [TownTableModel] {
        return try await memberRepository.getFavoriteList(accessToken: accessToken).toEntity
    }
    
    // 찜 등록, 해제
    func favorite(accessToken: String, cityCode: Int) async throws -> Bool {
        return try await memberRepository.favorite(accessToken: accessToken, cityCode: cityCode).toStatus
    }
}
