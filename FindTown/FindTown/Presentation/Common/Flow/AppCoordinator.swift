//
//  AppCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore

public final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        /// kakao, apple 자동로그인 유무 확인
        goToTabBar()
//        goToAuth()
    }
    
    private func goToAuth() {
    }
    
    private func goToTabBar() {
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
}
