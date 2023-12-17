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
    let appDIContainer: AppDIContainer
    
    init(
        presentationStyle: PresentationStyle,
        appDIContainer: AppDIContainer
    ) {
        self.presentationStyle = presentationStyle
        self.appDIContainer = appDIContainer
    }
    
    func initScene() -> UIViewController {
        let tabBarController: UITabBarController = BaseTabBarController()
        
        /// 홈 탭
        let homeCoordinator = HomeCoordinator(presentationStyle: .none,
                                              appDIContainer: appDIContainer)
        homeCoordinator.start()
        guard let homeViewController = homeCoordinator.navigationController else {
            return UIViewController()
        }
        homeViewController.tabBarItem = UITabBarItem(
                                            title: "동네 찾기",
                                            image: UIImage(named: "homeIcon"),
                                            tag: 0)
        
        /// 지도 탭
        let mapCoordinator = MapCoordinator(presentationStyle: .none,
                                            cityCode: nil,
                                            mapTransition: .tapBar,
                                            appDIContainer: appDIContainer)
        mapCoordinator.start()
        guard let mapViewController = mapCoordinator.navigationController else {
            return UIViewController()
        }
        mapViewController.tabBarItem = UITabBarItem(
                                        title: "동네 지도",
                                        image: UIImage(named: "mapIcon"),
                                        tag: 1)
        
        /// 플레이스 탭
        let placeCoordinator = PlaceCoordinator(presentationStyle: .none,
                                                appDIContainer: appDIContainer)
        placeCoordinator.start()
        guard let placeViewController = placeCoordinator.navigationController else {
            return UIViewController()
        }
        placeViewController.tabBarItem = UITabBarItem(
                                            title: "플레이스",
                                            image: UIImage(named: "placeIcon"),
                                            tag: 2)
        
        /// 찜 탭
        let favoriteCoordinator = FavoriteCoordinator(presentationStyle: .none,
                                                      appDIContainer: appDIContainer)
        favoriteCoordinator.start()
        guard let favoriteViewController = favoriteCoordinator.navigationController else { return UIViewController()
        }
        favoriteViewController.tabBarItem = UITabBarItem(
                                                title: "찜",
                                                image: UIImage(named: "favoriteIcon"),
                                                tag: 2)
        
        let homeVC = homeViewController.viewControllers.first as? HomeViewController
        if let favoriteVC = favoriteViewController.viewControllers.first as? FavoriteViewController {
            favoriteVC.delegate = homeVC
        }
        
        /// 마이페이지 탭
        let myPageCoordinator = MyPageCoordinator(presentationStyle: .none,
                                                  appDIContainer: appDIContainer)
        myPageCoordinator.start()
        guard let myPageViewController = myPageCoordinator.navigationController else {
            return UIViewController() }
        myPageViewController.tabBarItem = UITabBarItem(
                                            title: "마이",
                                            image: UIImage(named: "myPageIcon"),
                                            tag: 3)
        
        /// 탭 바
        tabBarController.viewControllers = [homeViewController,
                                            mapViewController,
                                            placeViewController,
                                            favoriteViewController,
                                            myPageViewController]
        
        return tabBarController
    }
}
