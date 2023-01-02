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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let loginViewModel = LoginViewModel(delegate: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        return loginViewController
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    func goToSignUpNickName() {
        guard let navigationController = navigationController else { return }
        SignUpNickNameCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
}
