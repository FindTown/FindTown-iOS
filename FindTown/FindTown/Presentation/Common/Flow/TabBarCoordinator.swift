//
//  TabBarCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore

final class TabBarCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    func initScene() -> UIViewController {
        let tabBarController: UITabBarController = BaseTabBarController()
        
        /// 홈 탭
        let homeCoordinator = HomeCoordinator(presentationStyle: .none)
        homeCoordinator.start()
        guard let homeViewController = homeCoordinator.navigationController else { return UIViewController() }
        homeViewController.tabBarItem = UITabBarItem(title: "동네 찾기", image: UIImage(named: "homeIcon"), tag: 0)
        
        /// 지도 탭
        let mapCoordinator = MapCoordinator(presentationStyle: .none)
        mapCoordinator.start()
        guard let mapViewController = mapCoordinator.navigationController else { return UIViewController() }
        mapViewController.tabBarItem = UITabBarItem(title: "동네 지도", image: UIImage(named: "mapIcon"), tag: 1)
        
        /// 찜 탭
        let favoriteCoordinator = FavoriteCoordinator(presentationStyle: .none)
        favoriteCoordinator.start()
        guard let favoriteViewController = favoriteCoordinator.navigationController else { return UIViewController() }
        favoriteViewController.tabBarItem = UITabBarItem(title: "찜", image: UIImage(named: "favoriteIcon"), tag: 2)
        
        /// 탭 바
        tabBarController.viewControllers = [homeViewController,
                                            mapViewController,
                                            favoriteViewController]
        
        return tabBarController
    }
}
