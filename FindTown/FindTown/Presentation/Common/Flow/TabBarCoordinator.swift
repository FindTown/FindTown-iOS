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
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    let townUseCase: TownUseCase
    
    init(
        presentationStyle: PresentationStyle,
        authUseCase: AuthUseCase,
        memberUseCase: MemberUseCase,
        townUseCase: TownUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        self.townUseCase = townUseCase
    }
    
    func initScene() -> UIViewController {
        let tabBarController: UITabBarController = BaseTabBarController()
        
        /// 홈 탭
        let homeCoordinator = HomeCoordinator(presentationStyle: .none,
                                              authUseCase: authUseCase,
                                              townUseCase: townUseCase,
                                              memberUseCase: memberUseCase)
        homeCoordinator.start()
        guard let homeViewController = homeCoordinator.navigationController else { return UIViewController() }
        homeViewController.tabBarItem = UITabBarItem(title: "동네 찾기", image: UIImage(named: "homeIcon"), tag: 0)
        
        /// 지도 탭
        let mapCoordinator = MapCoordinator(presentationStyle: .none, cityCode: nil, mapTransition: .tapBar)
        mapCoordinator.start()
        guard let mapViewController = mapCoordinator.navigationController else { return UIViewController() }
        mapViewController.tabBarItem = UITabBarItem(title: "동네 지도", image: UIImage(named: "mapIcon"), tag: 1)
        
        /// 찜 탭
        let favoriteCoordinator = FavoriteCoordinator(presentationStyle: .none,
                                                      townUseCase: townUseCase,
                                                      authUseCase: authUseCase,
                                                      memberUseCase: memberUseCase)
        favoriteCoordinator.start()
        guard let favoriteViewController = favoriteCoordinator.navigationController else { return UIViewController() }
        favoriteViewController.tabBarItem = UITabBarItem(title: "찜", image: UIImage(named: "favoriteIcon"), tag: 2)
        
        /// 마이페이지 탭
        let myPageCoordinator = MyPageCoordinator(presentationStyle: .none,
                                                  authUseCase: authUseCase,
                                                  memberUseCase: memberUseCase)
        myPageCoordinator.start()
        guard let myPageViewController = myPageCoordinator.navigationController else { return UIViewController() }
        myPageViewController.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "myPageIcon"), tag: 3)
        
        /// 탭 바
        tabBarController.viewControllers = [homeViewController,
                                            mapViewController,
                                            favoriteViewController,
                                            myPageViewController]
        
        return tabBarController
    }
}
