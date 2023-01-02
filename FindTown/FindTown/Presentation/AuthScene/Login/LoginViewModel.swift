//
//  LoginViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import Foundation

import FindTownCore

protocol LoginViewModelDelegate {
    func goToSignUpNickName()
}

protocol LoginViewModelType {
    func goToSignUpNickName()
}

final class LoginViewModel: BaseViewModel {
    let delegate: LoginViewModelDelegate
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
}

extension LoginViewModel: LoginViewModelType {
    func goToSignUpNickName() {
        delegate.goToSignUpNickName()
    }
}
