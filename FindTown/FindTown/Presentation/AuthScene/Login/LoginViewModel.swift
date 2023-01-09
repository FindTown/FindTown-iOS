//
//  LoginViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import Foundation

import FindTownCore

protocol LoginViewModelType {
    func goToNickname()
    func goToTabBar()
}

final class LoginViewModel: BaseViewModel {
    
    let delegate: LoginViewModelDelegate
    
    init(
        delegate: LoginViewModelDelegate
    ) {
        self.delegate = delegate
    }
}

extension LoginViewModel: LoginViewModelType {
    
    func goToNickname() {
        delegate.goToNickname()
    }
    
    func goToTabBar() {
        delegate.goToTabBar()
    }
}
