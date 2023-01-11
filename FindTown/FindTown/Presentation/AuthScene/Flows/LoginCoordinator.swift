//
//  LoginCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/06.
//

import UIKit

import FindTownCore

final class LoginCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    /// 로그인 화면
    internal func initScene() -> UIViewController {
        let loginViewModel = LoginViewModel(delegate: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        return loginViewController
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    
    func goToNickname() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = false
        SignupCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
    
    func goToTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
}
