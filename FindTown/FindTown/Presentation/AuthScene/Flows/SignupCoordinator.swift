//
//  LoginCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/29.
//

import UIKit

import FindTownCore

final class SignupCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    var signupUserModel = SignupUserModel()
    var parentCoordinator: FlowCoordinator
    
    init(presentationStyle: PresentationStyle,
         parentCoordinator: FlowCoordinator,
         authUseCase: AuthUseCase,
         userData: SigninUserModel,
         memberUseCase: MemberUseCase,
         providerType: ProviderType) {
        self.presentationStyle = presentationStyle
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        self.signupUserModel.memberId = userData.userId
        self.signupUserModel.email = userData.email
        self.signupUserModel.providerType = providerType
        self.parentCoordinator = parentCoordinator
    }
    
    /// 회원가입 닉네임 설정 화면
    internal func initScene() -> UIViewController {
        let nicknameViewModel = NicknameViewModel(delegate: self,
                                                  authUseCase: authUseCase,
                                                  signupUserModel: signupUserModel)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        return nicknameViewController
    }
    
    /// 회원가입 첫번째 정보입력 화면 (위치, 몇년 거주)
    internal func signUpInputLocationAndYearsScene(_ signupUserModel: SignupUserModel) -> UIViewController {
        let locationAndYearsViewModel = LocationAndYearsViewModel(delegate: self, signupUserModel: signupUserModel)
        let locationAndYearsViewController = LocationAndYearsViewController(viewModel: locationAndYearsViewModel)
        return locationAndYearsViewController
    }
    
    /// 회원가입 두번째 정보입력 화면 (동네 분위기)
    internal func signUpInputTownMoodScene(_ signupUserModel: SignupUserModel) -> UIViewController {
        let townMoodViewModel = TownMoodViewModel(delegate: self, signupUserModel: signupUserModel)
        let townMoodViewController = TownMoodViewController(viewModel: townMoodViewModel)
        return townMoodViewController
    }
    
    /// 회원가입 관심 있는 동네
    internal func signUpFavoriteTownScene(_ signupUserModel: SignupUserModel) -> UIViewController {
        let favoriteTownViewModel = FavoriteTownViewModel(delegate: self, signupUserModel: signupUserModel)
        let favoriteTownViewController = FavoriteTownViewController(viewModel: favoriteTownViewModel)
        return favoriteTownViewController
    }
    
    /// 이용약관
    internal func signUpAgreePolicyScene(_ signupUserModel: SignupUserModel) -> UIViewController {
        let agreePolicyViewModel = AgreePolicyViewModel(delegate: self, signupUserModel: signupUserModel, authUseCase: authUseCase)
        let agreePolicyViewController = AgreePolicyViewController(viewModel: agreePolicyViewModel)
        agreePolicyViewController.modalPresentationStyle = .overFullScreen
        return agreePolicyViewController
    }
}

extension SignupCoordinator: SignupViewModelDelegate {
    
    func goToLocationAndYears(_ signupUserModel: SignupUserModel) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(signUpInputLocationAndYearsScene(signupUserModel), animated: true)
    }
    
    func goToTownMood(_ signupUserModel: SignupUserModel) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(signUpInputTownMoodScene(signupUserModel), animated: true)
    }
    
    func goToFavorite(_ signupUserModel: SignupUserModel) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(signUpFavoriteTownScene(signupUserModel), animated: true)
    }
    
    func goToAgreePolicy(_ signupUserModel: SignupUserModel) {
        guard let navigationController = navigationController else { return }
        navigationController.present(signUpAgreePolicyScene(signupUserModel), animated: false)
    }
    
    /// Legacy
    func goToTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController),
                          authUseCase: authUseCase,
                          memberUseCase: memberUseCase).start()
    }
    
    func dismiss() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }
    
    func dismissAndGoToTapBar() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true) {
            if let parentCoordinator = self.parentCoordinator as? LoginCoordinator {
                parentCoordinator.goToTabBar()
            }
        }
    }
    
    func dismissAndShowError() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true) {
            if let parentCoordinator = self.parentCoordinator as? LoginCoordinator {
                parentCoordinator.goToTabBar()
            }
        }
    }
}
