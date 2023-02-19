//
//  ChangeNicknameViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/01.
//

import Foundation

import FindTownCore
import FindTownUI
import RxSwift
import RxRelay

protocol ChangeNicknameViewModelType {
    func fetchNickname(nickname: String)
}

final class ChangeNicknameViewModel: BaseViewModel {
    
    struct Input {
        let nickname = PublishSubject<String>()
        let nickNameCheckTrigger = PublishSubject<String>()
        let confirmButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nickNameStatus = PublishRelay<NicknameStatus>()
        let successNotice = PublishSubject<String>()
        let errorNotice = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var nicknameCheckTask: Task<Void, Error>?
    private var nicknameChangeTask: Task<Void, Error>?
    
    init(
        delegate: MyPageViewModelDelegate,
        authUseCase: AuthUseCase,
        memberUseCase: MemberUseCase
    ) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        
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
        
        self.input.confirmButtonTrigger
            .withLatestFrom(self.input.nickname)
            .bind(onNext: { [weak self] nickName in
                self?.setNickname(nickname: nickName)
            })
            .disposed(by: disposeBag)
    }
    
    private func setNickname(nickname: String) {
        self.changeNickname(nickname: nickname)
    }
}

// MARK: - Network

extension ChangeNicknameViewModel {
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
                nicknameCheckTask?.cancel()
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.output.errorNotice.onNext(())
                })
            }
            nicknameCheckTask?.cancel()
        }
    }
    
    func changeNickname(nickname: String) {
        self.nicknameChangeTask = Task {
            do {
                let accessToken = try await authUseCase.getAccessToken()
                let editSuccess = try await self.memberUseCase.changeNickname(nickName: nickname, accessToken: accessToken)
                await MainActor.run(body: {
                    if editSuccess {
                        self.output.successNotice.onNext(nickname)
                    } else {
                        self.output.errorNotice.onNext(())
                    }
                })
                nicknameChangeTask?.cancel()
            } catch (let error) {
                Log.error(error)
                await MainActor.run(body: {
                    self.output.errorNotice.onNext(())
                })
            }
            nicknameChangeTask?.cancel()
        }
    }
}

extension ChangeNicknameViewModel: ChangeNicknameViewModelType {
    func fetchNickname(nickname: String) {
        delegate.fetchNickname(nickname: nickname)
    }
}
