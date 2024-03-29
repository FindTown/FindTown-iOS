//
//  SignUpNickNameViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import Foundation

import FindTownCore
import FindTownUI
import RxSwift
import RxRelay

protocol NicknameViewModelType {
    func goToLocationAndYears(_ signupUserModel: SignupUserModel)
    func dismiss()
}

enum NicknameStatus {
    case none
    case complete
    case duplicate
    case includeSpecialChar
}

final class NicknameViewModel: BaseViewModel {
    
    struct Input {
        let nickname = PublishSubject<String>()
        let nickNameCheckTrigger = PublishSubject<String>()
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nickNameStatus = PublishRelay<NicknameStatus>()
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupViewModelDelegate
    
    // MARK: - UseCase
    
    let memberUseCase: MemberUseCase
    
    // MARK: - Model
    
    var signupUserModel: SignupUserModel
    
    // MARK: - Task
    
    private var nicknameCheckTask: Task<Void, Error>?
    
    init(
        delegate: SignupViewModelDelegate,
        memberUseCase: MemberUseCase,
        signupUserModel: SignupUserModel
    ) {
        self.delegate = delegate
        self.memberUseCase = memberUseCase
        self.signupUserModel = signupUserModel
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.nickname
            .bind { [weak self] _ in
                self?.output.nickNameStatus.accept(.none)
            }
            .disposed(by: disposeBag)
        
        self.input.nickNameCheckTrigger
            .bind { [weak self] nickName in
                if nickName.isValidNickname() {
                    self?.checkNicknameDuplicate(nickname: nickName)
                } else {
                    self?.output.nickNameStatus.accept(.includeSpecialChar)
                }
            }
            .disposed(by: disposeBag)
        
        self.input.nextButtonTrigger
            .withLatestFrom(self.input.nickname)
            .bind(onNext: { [weak self] nickName in
                self?.setNickname(nickname: nickName)
            })
            .disposed(by: disposeBag)
    }
    
    private func setNickname(nickname: String) {
        self.signupUserModel.nickname = nickname
        self.goToLocationAndYears(signupUserModel)
    }
}

// MARK: - Network

extension NicknameViewModel {
    func checkNicknameDuplicate(nickname: String) {
        self.nicknameCheckTask = Task {
            do {
                let existence = try await self.memberUseCase.checkNicknameDuplicate(nickName: nickname)
                await MainActor.run(body: {
                    if existence {
                        self.output.nickNameStatus.accept(.duplicate)
                    } else {
                        self.output.nickNameStatus.accept(.complete)
                    }
                })
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.output.errorNotice.onNext(())
                })
            }
            nicknameCheckTask?.cancel()
        }
    }
}

extension NicknameViewModel: NicknameViewModelType {
    func dismiss() {
        delegate.dismiss()
    }
    
    func goToLocationAndYears(_ signupUserModel: SignupUserModel) {
        delegate.goToLocationAndYears(signupUserModel)
    }
}
