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
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    
    init(presentationStyle: PresentationStyle, townUseCase: TownUseCase, authUseCase: AuthUseCase) {
        self.presentationStyle = presentationStyle
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
    }
    
    internal func initScene() -> UIViewController {
        let favoriteViewModel = FavoriteViewModel(delegate: self,
                                                  townUseCase: townUseCase,
                                                  authUseCsae: authUseCase)
        return FavoriteViewController(viewModel: favoriteViewModel)
    }
}

extension FavoriteCoordinator: FavoriteViewModelDelegate {

    func goToSignup() {
        guard let navigationController = navigationController else { return }
        AppCoordinator(navigationController: navigationController).start()
    }
    
    func goToTownIntro(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             townUseCase: townUseCase,
                             authUseCase: authUseCase,
                             cityCode: cityCode).start()
    }

}
