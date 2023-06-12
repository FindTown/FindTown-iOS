//
//  MyPageCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit
import FindTownCore

final class MyPageCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    let appDIContainer: AppDIContainer
    
    init(presentationStyle: PresentationStyle,
         appDIContainer: AppDIContainer) {
        self.presentationStyle = presentationStyle
        self.appDIContainer = appDIContainer
    }
    
    internal func initScene() -> UIViewController {
        if UserDefaultsSetting.isAnonymous {
            let myPageAnonymousViewModel = MyPageAnonymousViewModel(delegate: self)
            let myPageAnonymousViewController = MyPageAnonymousViewController(viewModel: myPageAnonymousViewModel)
            return myPageAnonymousViewController
        } else {
            let myPageViewModel = MyPageViewModel(delegate: self,
                                                  authUseCase: appDIContainer.authUseCase,
                                                  memberUseCase: appDIContainer.memberUseCase)
            let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
            return myPageViewController
        }
    }
    
    /// 닉네임 수정 화면
    internal func changeNicknameScene() -> UIViewController {
        let changeNicknameViewModel = ChangeNicknameViewModel(delegate: self,
                                                              authUseCase: appDIContainer.authUseCase,
                                                              memberUseCase: appDIContainer.memberUseCase)
        let changeNicknameViewController = ChangeNicknameViewController(viewModel: changeNicknameViewModel)
        changeNicknameViewController.hidesBottomBarWhenPushed = true
        return changeNicknameViewController
    }
    
    /// 내가 쓴 동네 후기 화면
    internal func myTownReviewScene() -> UIViewController {
        let myTownReviewViewModel = MyTownReviewViewModel(delegate: self,
                                                          authUseCase: appDIContainer.authUseCase,
                                                          memberUseCase: appDIContainer.memberUseCase)
        let myTownReviewViewController = MyTownReviewViewController(viewModel: myTownReviewViewModel)
        myTownReviewViewController.hidesBottomBarWhenPushed = true
        return myTownReviewViewController
    }
    
    internal func showInquiry() -> UIViewController {
        let inquiry = BaseWebViewController(webViewTitle: "문의하기", url: "https://docs.google.com/forms/d/e/1FAIpQLSejCcnZ_TFvlMRaYjgxUUneah1cgXjRwA0t_NrMKpiSNMYZrw/viewform")
        inquiry.hidesBottomBarWhenPushed = true
        return inquiry
    }
    
    internal func showPropose() -> UIViewController {
        let propose = BaseWebViewController(webViewTitle: "제안하기", url: "https://docs.google.com/forms/d/e/1FAIpQLSdaH4OytGqAnj87_q4vT41SqlmTaGtK6a-VI-IPyUq-Gl1tDw/viewform")
        propose.hidesBottomBarWhenPushed = true
        return propose
    }
    
    internal func showTerms() -> UIViewController {
        let terms = BaseWebViewController(webViewTitle: "이용약관", url: "https://lacy-ambulance-6f8.notion.site/30a635e779124ae7be1a4e05670607b8")
        terms.hidesBottomBarWhenPushed = true
        return terms
    }
    
    internal func showPersonalInfo() -> UIViewController {
        let personalInfo = BaseWebViewController(webViewTitle: "개인정보처리 방침", url: "https://yapp-workspace.notion.site/577e8340762440dd97ccb5ee16a57f8e")
        personalInfo.hidesBottomBarWhenPushed = true
        return personalInfo
    }
}

extension MyPageCoordinator: MyPageViewModelDelegate {
    func goToChangeNickname() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(changeNicknameScene(), animated: true)
    }
    
    func goToMyTownReview() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(myTownReviewScene(), animated: true)
    }
    
    func goToInquiry() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showInquiry(), animated: true)
    }
    
    func goToPropose() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showPropose(), animated: true)
    }
    
    func goToTerms() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showTerms(), animated: true)
    }
    
    func goToPersonalInfo() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showPersonalInfo(), animated: true)
    }
    
    func goToAuth() {
        guard let navigationController = navigationController else { return }
        LoginCoordinator(presentationStyle: .setViewController(navigationController: navigationController,                                                                                                                              modalTransitionStyle: .crossDissolve,
                                                               modalPresentationStyle: .overFullScreen),
                         appDIContainer: appDIContainer).start()
    }
    
    func fetchNickname(nickname: String) {
        guard let navigationController = navigationController else { return }
        if let mypageVC = navigationController.topViewController as? MyPageViewController {
            mypageVC.fetchNickname(nickname: nickname)
        }
    }
}
