//
//  FlowCoordinator.swift
//  
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit

public protocol FlowCoordinator: Coordinator {
    var presentationStyle: PresentationStyle { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
    func initScene() -> UIViewController
}

public extension FlowCoordinator {
    func start() {
        switch presentationStyle {
        case let .push(navigationController):
            self.navigationController = navigationController
            let initScene = initScene()
            initScene.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(initScene, animated: true)
        case .present(presenter: let presenter, modalPresentationStyle: let modalPresentationStyle):
            let navigationController = BaseNavigationController(rootViewController: initScene())
            self.navigationController = navigationController
            self.navigationController?.modalPresentationStyle = modalPresentationStyle
            presenter.present(navigationController, animated: true, completion: nil)
        case .setViewController(navigationController: let navigationController):
            self.navigationController?.viewControllers = []
            let newNavigation = BaseNavigationController(rootViewController: initScene())
            newNavigation.modalTransitionStyle = .flipHorizontal
            newNavigation.modalPresentationStyle = .overFullScreen
            navigationController.present(newNavigation, animated: true, completion: nil)
        case .none:
            self.navigationController = BaseNavigationController(rootViewController: initScene())
        }
    }
}
