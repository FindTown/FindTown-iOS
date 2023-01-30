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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let favoriteViewModel = FavoriteViewModel(delegate: self)
        return FavoriteViewController(viewModel: favoriteViewModel)
    }
    
    internal func goToTownIntroScene() -> UIViewController {
        let townIntroViewModel = TownIntroViewModel()
        let townIntroController = TownIntroViewController(viewModel: townIntroViewModel)
        return townIntroController
    }
}

extension FavoriteCoordinator: FavoriteViewModelDelegate {
    
    func goToSignup() {
        guard let navigationController = navigationController else { return }
        AppCoordinator(navigationController: navigationController).start()
    }
    
    func goToTownIntro() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(goToTownIntroScene(), animated: true)
    }
}
