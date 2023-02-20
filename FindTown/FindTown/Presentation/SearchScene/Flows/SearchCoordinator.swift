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
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase = AuthUseCase()
    
    init(
        presentationStyle: PresentationStyle,
        townUseCase: TownUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.townUseCase = townUseCase
    }
    
    internal func initScene() -> UIViewController {
        let searchViewModel = SearchViewModel(delegate: self)
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        return searchViewController
    }
    
    internal func showVillageListScene(selectCountyData: String) -> UIViewController {
        let showVillageListViewModel = ShowVillageListViewModel(delegate: self,
                                                                townUseCase: townUseCase,
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

extension SearchCoordinator: SearchViewModelDelegate, ShowVillageListViewModelDelegate {
    func goToTownIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             townUseCase: townUseCase,
                             authUseCase: authUseCase,
                             cityCode: cityCode).start()
    }
    
    func goToTownMap(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController), cityCode: cityCode).start()
    }
    
    func goToShowVillageList(selectCountyData: String) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showVillageListScene(selectCountyData: selectCountyData), animated: true)
    }
    
    func popUpServiceMap() {
        guard let navigationController = navigationController else { return }
        navigationController.present(showServiceMapScene(), animated: false)
    }
    
    
}
