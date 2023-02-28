//
//  FavoriteCoordinator.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import FindTownCore

final class FavoriteCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    var delegate: FavoriteViewModelDelegate?
    let appDIContainer: AppDIContainer
    
    init(presentationStyle: PresentationStyle,
         appDIContainer: AppDIContainer) {
        
        self.presentationStyle = presentationStyle
        self.appDIContainer = appDIContainer
    }
    
    internal func initScene() -> UIViewController {
        let favoriteViewModel = FavoriteViewModel(delegate: self,
                                                  townUseCase: appDIContainer.townUseCase,
                                                  authUseCase: appDIContainer.authUseCase,
                                                  memberUseCase: appDIContainer.memberUseCase)
        return FavoriteViewController(viewModel: favoriteViewModel)
    }
}

extension FavoriteCoordinator: FavoriteViewModelDelegate {

    func goToLogin() {
        guard let navigationController = navigationController else { return }
        LoginCoordinator(presentationStyle: .setViewController(navigationController: navigationController,
                                                               modalPresentationStyle: .overFullScreen),
                                                               appDIContainer: appDIContainer).start()
    }
    
    func goToTownIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             appDIContainer: appDIContainer,
                             cityCode: cityCode).start()
    }
    
    func goToTownMap(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController),
                       cityCode: cityCode,
                       mapTransition: .push,
                       appDIContainer: appDIContainer).start()
    }
}
