//
//  GuSearchCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import UIKit

import FindTownCore

final class SearchCoordinator: FlowCoordinator {
    
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
    
    internal func initScene() -> UIViewController {
        let searchViewModel = SearchViewModel(delegate: self)
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        return searchViewController
    }
    
    internal func showVillageListScene(selectCountyData: String) -> UIViewController {
        let showVillageListViewModel = ShowVillageListViewModel(delegate: self,
                                                                townUseCase: appDIContainer.townUseCase,
                                                                authUseCase: appDIContainer.authUseCase,
                                                                memberUseCase: appDIContainer.memberUseCase,
                                                                selectCountyData: selectCountyData)
        let showVillageListViewController = ShowVillageListViewController(viewModel: showVillageListViewModel)
        return showVillageListViewController
    }
    
    internal func showServiceMapScene() -> UIViewController {
        let serviceMapPopUpViewController = ServiceMapPopUpViewController()
        serviceMapPopUpViewController.modalPresentationStyle = .overFullScreen
        return serviceMapPopUpViewController
    }
}

extension SearchCoordinator: SearchViewModelDelegate {
    
    func goToShowVillageList(selectCountyData: String) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showVillageListScene(selectCountyData: selectCountyData), animated: true)
    }
    
    func popUpServiceMap() {
        guard let navigationController = navigationController else { return }
        navigationController.present(showServiceMapScene(), animated: false)
    }
    
    func goToTownMap(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController),
                       cityCode: cityCode,
                       mapTransition: .push,
                       appDIContainer: appDIContainer).start()
    }
    
    func goToTownIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             appDIContainer: appDIContainer,
                             cityCode: cityCode).start()
    }
    
    func goToAuth() {
        guard let navigationController = navigationController else { return }
        LoginCoordinator(presentationStyle: .setViewController(navigationController: navigationController,
                                                               modalTransitionStyle: .crossDissolve,
                                                               modalPresentationStyle: .overFullScreen),
                         appDIContainer: appDIContainer).start()
    }
}
