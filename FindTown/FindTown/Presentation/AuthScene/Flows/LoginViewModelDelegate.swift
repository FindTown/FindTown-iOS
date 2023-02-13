//
//  LoginCoordinatorDelegate.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/06.
//

import Foundation

protocol LoginViewModelDelegate {
    func goToNickname(userData: SigninUserModel, providerType: ProviderType)
    func goToTabBar(isAnonymous: Bool)
}
