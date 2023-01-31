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
    func goToNickname(userData: SigninUserModel, providerType: ProviderType)
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
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    
    // MARK: - Task
    
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
            .subscribe(onNext: { [weak self] _ in
                self?.login(providerType: .kakao)
            })
            .disposed(by: disposeBag)
        
        self.input.appleSigninTrigger
            .bind { [weak self] _ in
                self?.login(providerType: .apple)
            }
            .disposed(by: disposeBag)
        
        self.input.anonymousTrigger
            .bind { [weak self] _ in
                self?.goToTabBar()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension LoginViewModel {
    func login(providerType: ProviderType) {
        loginTask = Task {
            do {
                let (message, userData) = try await self.authUseCase.login(authType: providerType)
                await MainActor.run {
                    if message == "비회원 계정입니다." {
                        self.goToNickname(userData: userData, providerType: .kakao)
                    } else {
                        self.goToTabBar()
                    }
                }
                loginTask?.cancel()
            } catch (let error) {
                Log.error(error)
            }
        }
    }
}

extension LoginViewModel: LoginViewModelType {
    func goToTabBar() {
        delegate.goToTabBar()
    }
    func goToNickname(userData: SigninUserModel, providerType: ProviderType) {
        delegate.goToNickname(userData: userData, providerType: providerType)
    }
}
