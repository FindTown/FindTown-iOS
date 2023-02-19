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
    
    init(
        presentationStyle: PresentationStyle,
        authUseCase: AuthUseCase,
        townUseCase: TownUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.authUseCase = authUseCase
        self.townUseCase = townUseCase
    }
    
    internal func initScene() -> UIViewController {
        let homeViewModel = HomeViewModel(delegate: self,
                                          authUseCase: authUseCase,
                                          townUseCase: townUseCase)
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
                          townUseCase: townUseCase).start()
    }
}
