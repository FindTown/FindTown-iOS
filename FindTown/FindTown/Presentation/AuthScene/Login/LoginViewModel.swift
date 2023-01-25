//
//  LoginViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import Foundation

import FindTownCore
import RxSwift

protocol LoginViewModelType {
    func goToTabBar()
    func goToNickname()
}

final class LoginViewModel: BaseViewModel {
    
    struct Input {
        let kakaoSigninTrigger = PublishSubject<Void>()
        let appleSigninTrigger = PublishSubject<Void>()
        let anonymousTrigger = PublishSubject<Void>()
    }
    
    struct Output {
//        let signinOutput = PublishSubject<SigninRequest>()
    }
    
    let input = Input()
    var output = Output()
    
    let delegate: LoginViewModelDelegate
    let authUseCase: AuthUseCase
    
    private var loginTask: Task<Void, Error>?
    
    init(
        delegate: LoginViewModelDelegate,
        authUseCase: AuthUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        
        super.init()
        
        self.bind()
    }
    
    func bind() {
        
        self.input.kakaoSigninTrigger
            .subscribe(onNext: {
                self.loginWithKakao()
            })
            .disposed(by: disposeBag)
        
//        self.input.kakaoSigninTrigger
//            .flatMapLatest { self.kakaoManager.signin() }
//            .subscribe(onNext: { [weak self] signinRequest in
//
//                TokenManager.shared.createTokens(accessToken: signinRequest.accessToken,
//                                                 refreshToken: signinRequest.refreshToken)
//
//                // 유저 정보가 있으면
////                self?.goToTabBar()
//
//                // 없으면
//                self?.goToNickname()
//
//            },onError: { err in
//                let error = err as? SocialLoginError
//                print("error \(error!)")
//                print("err \(err.localizedDescription)")
//            })
//            .disposed(by: disposeBag)
        
        self.input.appleSigninTrigger
            .bind {
                print("appleSigninTrigger")
            }
            .disposed(by: disposeBag)
        
        self.input.anonymousTrigger
            .bind {
                print("anonymousTrigger")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension LoginViewModel {
    func loginWithKakao() {
        Task {
            do {
                try await self.authUseCase.login(authType: .kakao)
            } catch (let error) {
                print(error)
            }
        }
    }
}

extension LoginViewModel: LoginViewModelType {
    func goToTabBar() {
        delegate.goToTabBar()
    }
    func goToNickname() {
        delegate.goToNickname()
    }
}
