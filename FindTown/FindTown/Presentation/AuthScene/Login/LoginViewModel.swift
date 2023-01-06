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
    func goToTabBar()
}

final class LoginViewModel: BaseViewModel {
    
    let delegate: LoginCoordinatorDelegate
    
    init(
        delegate: LoginCoordinatorDelegate
    ) {
        self.delegate = delegate
    }
}

extension LoginViewModel: LoginViewModelType {
    
    func goToNicnName() {
        delegate.goToNickname()
    }
    
    func goToTabBar() {
        delegate.goToTabBar()
    }
}
