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

protocol SignUpNickNameViewModelDelegate {
    func goToFirstInfo()
}

protocol SignUpNickNameViewModelType {
    func goToFirstInfo()
}

enum SignUpNickNameStatus {
    case none
    case complete
    case duplicate
    case inSpecialChar
}

final class SignUpNickNameViewModel: BaseViewModel {
    
    struct Input {
        let nickname = PublishSubject<String>()
        let nickNameCheckTrigger = PublishSubject<String>()
    }
    
    struct Output {
        let nickNameStatus = PublishRelay<SignUpNickNameStatus>()
        let buttonsSelected = PublishRelay<Bool>()
    }
    
    let input = Input()
    var output = Output()
    var delegate: SignUpNickNameViewModelDelegate
    
    init(delegate: SignUpNickNameViewModelDelegate) {
        self.delegate = delegate
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.nickname
            .bind { [weak self] _ in
                self?.output.buttonsSelected.accept(true)
            }
            .disposed(by: disposeBag)
        
        self.input.nickNameCheckTrigger
            .bind { [weak self] nickName in
                // 특수문자 없으면 + 공백이 아니면 닉네임 체크
                if nickName.isValidNickname() {
                    
                    // 닉네임 중복 체크 들어갈 자리
                    self?.output.nickNameStatus.accept(.complete)
                    
                } else {
                    self?.output.nickNameStatus.accept(.inSpecialChar)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SignUpNickNameViewModel: SignUpNickNameViewModelType {
    func goToFirstInfo() {
        delegate.goToFirstInfo()
    }
}
