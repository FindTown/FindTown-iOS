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
    
    func getMemberInformation(accessToken: String) async throws -> MemberInformationDTO {
        return try await memberRepository.getMemberInformation(accessToken)
    }
}
