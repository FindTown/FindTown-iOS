//
//  AgreePolicyViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/09.
//

import Foundation

import FindTownUI
import FindTownCore
import RxSwift
import RxRelay

protocol AgreePolicyViewModelType {
    func goToTabBar()
    func dismiss()
    func dismissAndGoToTabBar()
    func dismissAndShowError()
}

final class AgreePolicyViewModel: BaseViewModel {
    
    struct Input {
        let allAgree = PublishSubject<Bool>()
        let policy = PublishSubject<Bool>()
        let personalInfo = PublishSubject<Bool>()
        
        let confirmButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let buttonsSelected = PublishRelay<Bool>()
        let confirmButtonEnabled = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupViewModelDelegate
    var signupUserModel: SignupUserModel
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    
    // MARK: - Task
    
    private var registerTask: Task<Void, Error>?
    
    init(
        delegate: SignupViewModelDelegate,
        signupUserModel: SignupUserModel,
        authUseCase: AuthUseCase
    ) {
        self.delegate = delegate
        self.signupUserModel = signupUserModel
        self.authUseCase = authUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.allAgree
            .bind { [weak self] in
                self?.input.policy.onNext($0)
                self?.input.personalInfo.onNext($0)
                self?.output.buttonsSelected.accept($0)
            }
            .disposed(by: disposeBag)
        
        self.input.confirmButtonTrigger
            .bind { [weak self] in
                guard let signupUserModel = self?.signupUserModel else { return }
                self?.signup(signupUserModel: signupUserModel)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.policy, input.personalInfo)
            .map { [weak self] (policy, personalInfo) in
                self?.signupUserModel.useAgreeYn = policy
                self?.signupUserModel.privaxyAgreeYn = personalInfo
                return policy && personalInfo
            }
            .bind { [weak self] in
                self?.output.confirmButtonEnabled.accept($0)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension AgreePolicyViewModel {
    func signup(signupUserModel: SignupUserModel) {
        self.registerTask = Task {
            do {
                let token = try await self.authUseCase.signup(signupUerModel: signupUserModel)
                await MainActor.run {
                    self.dismissAndGoToTabBar()
                }
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.dismissAndShowError()
                })
            }
            registerTask?.cancel()
        }
    }
}

extension AgreePolicyViewModel: AgreePolicyViewModelType {
    
    func goToTabBar() {
        delegate.goToTabBar()
    }
    
    func dismiss() {
        delegate.dismiss()
    }
    
    func dismissAndShowError() {
        delegate.dismissAndShowError()
    }
    
    func dismissAndGoToTabBar() {
        delegate.dismissAndGoToTapBar()
    }
}
