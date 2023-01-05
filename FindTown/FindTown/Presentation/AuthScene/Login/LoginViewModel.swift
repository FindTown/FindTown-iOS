//
//  LoginViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import Foundation

import FindTownCore

protocol LoginViewModelType {
    func goToNicnName()
}

final class LoginViewModel: BaseViewModel {
    let delegate: SignupCoordinatorDelegate
    
    init(
        delegate: SignupCoordinatorDelegate
    ) {
        self.delegate = delegate
    }
}

extension LoginViewModel: LoginViewModelType {
    func goToNicnName() {
        delegate.goToNickname()
    }
}
