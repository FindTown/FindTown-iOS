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
    let authUseCase: AuthUseCase
    
    init(
        presentationStyle: PresentationStyle,
        authUseCase: AuthUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.authUseCase = authUseCase
    }
    
    internal func initScene() -> UIViewController {
        let myPageViewModel = MyPageViewModel(delegate: self)
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        return myPageViewController
    }
    
    /// 닉네임 수정 화면
    internal func changeNicknameScene() -> UIViewController {
        let changeNicknameViewModel = ChangeNicknameViewModel(delegate: self,
                                                              authUseCase: authUseCase)
        let changeNicknameViewController = ChangeNicknameViewController(viewModel: changeNicknameViewModel)
        changeNicknameViewController.hidesBottomBarWhenPushed = true
        return changeNicknameViewController
    }
    
    /// 내가 쓴 동네 후기 화면
    internal func myTownReviewScene() -> UIViewController {
        let myTownReviewViewModel = MyTownReviewViewModel(delegate: self)
        let myTownReviewViewController = MyTownReviewViewController(viewModel: myTownReviewViewModel)
        myTownReviewViewController.hidesBottomBarWhenPushed = true
        return myTownReviewViewController
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
}
