//
//  LoginCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore
import FindTownUI

final class LoginCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    let appDIContainer: AppDIContainer
    
    init(presentationStyle: PresentationStyle,
         appDIContainer: AppDIContainer) {
        self.presentationStyle = presentationStyle
        self.appDIContainer = appDIContainer
    }
    
    internal func initScene() -> UIViewController {
        let loginViewModel = LoginViewModel(delegate: self,
                                            authUseCase: appDIContainer.authUseCase)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        return loginViewController
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    
    func goToTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController),
                          appDIContainer: appDIContainer).start()
    }
    
    func goToNickname(userData: SigninUserModel, providerType: ProviderType) {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = false
        SignupCoordinator(presentationStyle: .presentFlow(navigationController: navigationController,
                                                          modalPresentationStyle: .overFullScreen),
                          parentCoordinator: self,
                          appDIContainer: appDIContainer,
                          userData: userData,
                          providerType: providerType).start()
    }
    
    func showErrorNoticeAlert() {
        guard let navigationController = navigationController else { return }
        if let loginViewController = navigationController.topViewController as? LoginViewController {
            loginViewController.viewModel?.showErrorNoticeAlert()
        }
    }
}
