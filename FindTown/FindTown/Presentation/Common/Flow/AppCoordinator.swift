//
//  AppCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore
import KakaoSDKAuth
import KakaoSDKUser

import FindTownNetwork

public final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let authUseCase = AuthUseCase()
    
    private var autoSignTask: Task<Void, Error>?
    
    required init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
        self.goToAuth()
        
        // 자동 로그인
//        autoSignTask = Task {
//            do {
//                let accessToken = try await self.authUseCase.getTokenData()
//                let userId = try await self.authUseCase.memberConfirm(accessToken: accessToken)
//                await MainActor.run {
//                    self.goToTabBar()
//                }
//                autoSignTask?.cancel()
//            } catch (let error) {
//                if let error = error as? FTNetworkError,
//                   FTNetworkError.isUnauthorized(error: error) {
//                    await MainActor.run {
//                        self.goToAuth()
//                    }
//                } else {
//                    Log.error(error)
//                }
//            }
//        }
    }
    
    private func goToAuth() {
        navigationController.isNavigationBarHidden = true
        LoginCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
    
    private func goToTabBar() {
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
}
