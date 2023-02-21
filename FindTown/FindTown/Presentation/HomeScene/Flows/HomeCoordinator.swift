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
    let authUseCase: AuthUseCase
    let townUseCase: TownUseCase
    let memberUseCase: MemberUseCase
    
    init(
        presentationStyle: PresentationStyle,
        authUseCase: AuthUseCase,
        townUseCase: TownUseCase,
        memberUseCase: MemberUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.authUseCase = authUseCase
        self.townUseCase = townUseCase
        self.memberUseCase = memberUseCase
    }
    
    internal func initScene() -> UIViewController {
        let homeViewModel = HomeViewModel(delegate: self,
                                          authUseCase: authUseCase,
                                          townUseCase: townUseCase,
                                          memberUseCase: memberUseCase)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        return homeViewController
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: FilterModel) {
        guard let navigationController = navigationController else { return }
        FilterSheetCoordinator(presentationStyle: .present(navigationController: navigationController,
                                                           modalPresentationStyle: .overFullScreen),
                               filterSheetType: filterSheetType,
                               filterDataSource: filterDataSource).start()
    }
    
    func goToGuSearchView() {
        guard let navigationController = navigationController else { return }
        SearchCoordinator(presentationStyle: .push(navigationController: navigationController),
                          townUseCase: townUseCase,
                          authUseCase: authUseCase,
                          memberUseCase: memberUseCase).start()
    }
    
    func goToTownIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             townUseCase: townUseCase,
                             authUseCase: authUseCase,
                             memberUseCase: memberUseCase,
                             cityCode: cityCode).start()
    }
    
    func goToTownMap(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController),
                       cityCode: cityCode,
                       mapTransition: .push).start()
    }
    
    func goToAuth() {
        guard let navigationController = navigationController else { return }
        LoginCoordinator(presentationStyle: .setViewController(navigationController: navigationController,
                                                               modalTransitionStyle: .crossDissolve,
                                                               modalPresentationStyle: .overFullScreen)).start()
    }
}
