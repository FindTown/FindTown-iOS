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
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupViewModelDelegate
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    
    init(
        delegate: SignupViewModelDelegate,
        authUseCase: AuthUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        
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
                // 특수문자 없으면 + 공백이 아니면 닉네임 체크
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
        // 1. nickname 임시로 set
        print("setNickname \(nickname)")

        var signupUserModel = SignupUserModel()
        signupUserModel.nickname = nickname
        
        // 2. after goToLocationAndYears
        self.goToLocationAndYears(signupUserModel)
    }
}

// MARK: - Network

extension NicknameViewModel {
    func checkNicknameDuplicate(nickname: String) {
        Task {
            do {
                let existence = try await self.authUseCase.checkNicknameDuplicate(nickName: nickname)
                if existence {
                    self.output.nickNameStatus.accept(.duplicate)
                } else {
                    self.output.nickNameStatus.accept(.complete)
                }
            } catch (let error) {
                print(error)
            }
        }
    }
}

extension NicknameViewModel: NicknameViewModelType {
    func goToLocationAndYears(_ signupUserModel: SignupUserModel) {
        delegate.goToLocationAndYears(signupUserModel)
    }
}
