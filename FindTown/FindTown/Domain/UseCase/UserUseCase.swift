//
//  UserUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation

final class UserUseCase {
    
    let userRepository: UserRepository
    
    init() {
        self.userRepository = UserRepository()
    }
    
    func getUserInfomation(bearerToken: String) async throws -> String {
        return try await userRepository.getUserInfomation(bearerToken)
    }
}
