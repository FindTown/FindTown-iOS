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
        case .push(let navigationController):
            self.navigationController = navigationController
            let initScene = initScene()
            initScene.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(initScene, animated: true)
        case .present(let navigationController,
                      let modalPresentationStyle):
            self.navigationController = navigationController
            let initScene = initScene()
            initScene.modalPresentationStyle = modalPresentationStyle
            self.navigationController?.present(initScene, animated: true, completion: nil)
        case .presentFlow(let navigationController,
                          let modalPresentationStyle):
            self.navigationController = navigationController
            let initScene = initScene()
            let modalNavigationController = BaseNavigationController(rootViewController: initScene)
            modalNavigationController.modalPresentationStyle = modalPresentationStyle
            self.navigationController?.present(modalNavigationController, animated: true) {
                self.navigationController = modalNavigationController
            }
        case .setViewController(let navigationController,
                                let modalTransitionStyle,
                                let modalPresentationStyle):
            self.navigationController?.viewControllers = []
            let newNavigation = BaseNavigationController(rootViewController: initScene())
            newNavigation.modalTransitionStyle = modalTransitionStyle
            newNavigation.modalPresentationStyle = modalPresentationStyle
            navigationController.present(newNavigation, animated: true) {
                self.navigationController = newNavigation
            }
        case .none:
            self.navigationController = BaseNavigationController(rootViewController: initScene())
        }
    }
}
