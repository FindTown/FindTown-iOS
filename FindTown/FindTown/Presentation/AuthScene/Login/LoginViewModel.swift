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
        let errorNotice = PublishSubject<Void>()
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
    
    func showErrorNoticeAlert() {
        self.output.errorNotice.onNext(())
    }
}

// MARK: - Network

extension LoginViewModel {
    func login(providerType: ProviderType) {
        loginTask = Task {
            do {
                try await self.authUseCase.login(authType: providerType)
                await MainActor.run {
                    self.goToTabBar()
                }
                loginTask?.cancel()
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                }
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
