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
    
}

final class ChangeNicknameViewModel: BaseViewModel {
    
    struct Input {
        let nickname = PublishSubject<String>()
        let nickNameCheckTrigger = PublishSubject<String>()
        let confirmButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nickNameStatus = PublishRelay<NicknameStatus>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    // MARK: - UseCase
    
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var nicknameCheckTask: Task<Void, Error>?
    
    init(
        delegate: MyPageViewModelDelegate,
        memberUseCase: MemberUseCase
    ) {
        self.delegate = delegate
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
    
    // 닉네임 변경 + 뒤로가기
    private func setNickname(nickname: String) {
        print("nickname set \(nickname)")
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
                print(error)
            }
        }
    }
}

extension ChangeNicknameViewModel: ChangeNicknameViewModelType {
    
}
