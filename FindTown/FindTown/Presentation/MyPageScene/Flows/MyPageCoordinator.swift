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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let myPageViewModel = MyPageViewModel(delegate: self)
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        return myPageViewController
    }
}

extension MyPageCoordinator: MyPageViewModelDelegate {
    
}
