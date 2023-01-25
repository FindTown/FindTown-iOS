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
}

extension FavoriteCoordinator: FavoriteViewModelDelegate {
    
    func goToSignup() {
        guard let navigationController = navigationController else { return }
        AppCoordinator(navigationController: navigationController).start()
    }
}
