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
    let appDIContainer: AppDIContainer
    
    private var autoSignTask: Task<Void, Error>?
    
    required init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    public func start() {
        
        // 자동 로그인
        autoSignTask = Task {
            do {
                let accessToken = try await self.appDIContainer.authUseCase.getAccessToken()
                let userId = try await self.appDIContainer.authUseCase.memberConfirm(accessToken: accessToken)
                await MainActor.run {
                    UserDefaultsSetting.isAnonymous = false
                    self.goToTabBar()
                }
                autoSignTask?.cancel()
            } catch (let error) {
                await MainActor.run {
                    self.goToAuth()
                }
                Log.error(error)
            }
        }
    }
    
    private func goToAuth() {
        navigationController.isNavigationBarHidden = true
        LoginCoordinator(presentationStyle: .push(navigationController: navigationController),
                         appDIContainer: appDIContainer).start()
    }
    
    private func goToTabBar() {
        navigationController.isNavigationBarHidden = true
        TabBarCoordinator(presentationStyle: .push(navigationController: navigationController),
                          appDIContainer: appDIContainer).start()
    }
}
