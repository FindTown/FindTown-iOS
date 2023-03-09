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
        return DefaultAuthUseCase(kakaoAuthRepository: makeKakaoRepository(),
                           appleAuthRespository: makeAppleRepository(),
                           authRepository: makeAuthRepository(),
                           tokenRepository: makeTokenRepository())
    }
    
    func memberUseCase() -> MemberUseCase {
        return DefaultMemberUseCase(memberRepository: makeMemberRepository(),
                             tokenRepository: makeTokenRepository())
    }
    
    func townUseCase() -> TownUseCase {
        return DefaultTownUseCase(townRepository: makeTownRepository())
    }
    
    func mapUseCase() -> MapUseCase {
        return DefaultMapUseCase(mapRepository: makeMapRepository())
    }
    
    // MARK: - Repositories
    func makeKakaoRepository() -> KakaoAuthRepository {
        return DefaultKakaoAuthRepository()
    }
    
    func makeAppleRepository() -> AppleAuthRespository {
        return DefaultAppleAuthRespository()
    }
    
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository()
    }
    
    func makeTokenRepository() -> TokenRepository {
        return DefaultTokenRepository()
    }
    
    func makeTownRepository() -> TownRepository {
        return DefaultTownRepository()
    }
    
    func makeMapRepository() -> MapRepository {
        return DefaultMapRepository()
    }
    
    func makeMemberRepository() -> MemberRepository {
        return DefaultMemberRepository()
    }
}
