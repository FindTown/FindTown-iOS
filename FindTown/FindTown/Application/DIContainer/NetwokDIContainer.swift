//
//  NetwokDIContainer.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/27.
//

import UIKit

final class NetwokDIContainer {

    // MARK: - Use Cases
    func authUseCase() -> AuthUseCase {
        return AuthUseCase(kakaoAuthRepository: makeKakaoRepository(),
                           appleAuthRespository: makeAppleRepository(),
                           authRepository: makeAuthRepository(),
                           tokenRepository: makeTokenRepository())
    }
    
    func memberUseCase() -> MemberUseCase {
        return MemberUseCase(memberRepository: makeMemberRepository(),
                             tokenRepository: makeTokenRepository())
    }
    
    func townUseCase() -> TownUseCase {
        return TownUseCase(townRepository: makeTownRepository())
    }
    
    func mapUseCase() -> MapUseCase {
        return MapUseCase(mapRepository: makeMapRepository())
    }
    
    // MARK: - Repositories
    func makeKakaoRepository() -> DefaultKakaoAuthRepository {
        return DefaultKakaoAuthRepository()
    }
    
    func makeAppleRepository() -> DefaultAppleAuthRespository {
        return DefaultAppleAuthRespository()
    }
    
    func makeAuthRepository() -> DefaultAuthRepository {
        return DefaultAuthRepository()
    }
    
    func makeTokenRepository() -> DefaultTokenRepository {
        return DefaultTokenRepository()
    }
    
    func makeTownRepository() -> DefaultTownRepository {
        return DefaultTownRepository()
    }
    
    func makeMapRepository() -> DefaultMapRepository {
        return DefaultMapRepository()
    }
    
    func makeMemberRepository() -> DefaultMemberRepository {
        return DefaultMemberRepository()
    }
}
