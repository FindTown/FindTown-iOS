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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let favoriteViewModel = Favorite1ViewModel(delegate: self)
        return Favorite1ViewController(viewModel: favoriteViewModel)
    }
    
}

extension FavoriteCoordinator: Favorite1ViewModelDelegate {
    
    func goToSignup() {
        guard let navigationController = navigationController else { return }
        navigationController.isNavigationBarHidden = true
        LoginCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
//        LoginCoordinator(presentationStyle: <#T##PresentationStyle#>)
    }
}
