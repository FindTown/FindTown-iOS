//
//  SignUpNickNameCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore

final class SignUpNickNameCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let signUpNickNameViewModel = SignUpNickNameViewModel(delegate: self)
        let signUpNickNameViewController = SignUpNickNameViewController(viewModel: signUpNickNameViewModel)
        return signUpNickNameViewController
    }
}

extension SignUpNickNameCoordinator: SignUpNickNameViewModelDelegate {
    func goToFirstInfo() {
        
    }
}
