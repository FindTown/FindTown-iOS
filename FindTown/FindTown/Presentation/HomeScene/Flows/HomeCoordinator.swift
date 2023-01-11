//
//  HomeCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore

final class HomeCoordinator: FlowCoordinator {

    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let homeViewModel = HomeViewModel(delegate: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        return homeViewController
    }
    
}

extension HomeCoordinator: HomeViewModelDelegate {
    
    func push() {
        guard let navigationController = navigationController else { return }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
    
    func present() {
        guard let navigationController = navigationController else { return }
        HomeCoordinator(presentationStyle: .present(navigationController: navigationController)).start()
    }
    
    func pop() {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }
    
    func setViewController() {
        guard let navigationController = navigationController else { return }
        TabBarCoordinator(presentationStyle: .setViewController(navigationController: navigationController)).start()
    }
    
}
