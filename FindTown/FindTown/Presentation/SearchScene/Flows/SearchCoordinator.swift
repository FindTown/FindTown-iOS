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
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    
    init(
        presentationStyle: PresentationStyle,
        townUseCase: TownUseCase,
        authUseCase: AuthUseCase,
        memberUseCase: MemberUseCase
    ) {
        self.presentationStyle = presentationStyle
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
    }
    
    internal func initScene() -> UIViewController {
        let searchViewModel = SearchViewModel(delegate: self)
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        return searchViewController
    }
    
    internal func showVillageListScene(selectCountyData: String) -> UIViewController {
        let showVillageListViewModel = ShowVillageListViewModel(delegate: self,
                                                                townUseCase: townUseCase,
                                                                authUseCase: authUseCase,
                                                                memberUseCase: memberUseCase,
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
    
    func goToTownIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             townUseCase: townUseCase,
                             authUseCase: authUseCase,
                             memberUseCase: memberUseCase,
                             cityCode: cityCode).start()
    }
    
    func goToAuth() {
        guard let navigationController = navigationController else { return }
        LoginCoordinator(presentationStyle: .setViewController(navigationController: navigationController,
                                                               modalTransitionStyle: .crossDissolve,
                                                               modalPresentationStyle: .overFullScreen)).start()
    }
}
