//
//  LoginCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore

final class LoginCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    let authUseCase = AuthUseCase()
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let loginViewModel = LoginViewModel(delegate: self,
                                            authUseCase: authUseCase)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        return loginViewController
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    
    func goToTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
    
    func goToNickname(userData: SigninUserModel, providerType: ProviderType) {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = false
        SignupCoordinator(presentationStyle: .push(navigationController: navigationController),
                                                   authUseCase: authUseCase,
                                                   userData: userData,
                                                   providerType: providerType).start()
    }
}
