//
//  UserUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation

final class MemberUseCase {
    
    let memberRepository: MemberRepository
    
    init() {
        self.memberRepository = MemberRepository()
    }
    
    func getMemberInfomation(bearerToken: String) async throws -> MemberInfoDTO {
        return try await memberRepository.getMemberInfomation(bearerToken)
    }
}
