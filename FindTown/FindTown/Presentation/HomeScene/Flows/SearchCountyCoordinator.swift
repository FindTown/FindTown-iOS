//
//  GuSearchCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import UIKit

import FindTownCore

final class SearchCountyCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let selectCountyViewModel = SelectCountyViewModel(delegate: self)
        let selectCountyViewController = SelectCountyViewController(viewModel: selectCountyViewModel)
        return selectCountyViewController
    }
    
    internal func showVillageListScene(selectCountyData: String) -> UIViewController {
        let showVillageListViewModel = ShowVillageListViewModel(selectCountyData: selectCountyData)
        let showVillageListViewController = ShowVillageListViewController(viewModel: showVillageListViewModel)
        return showVillageListViewController
    }
    
    internal func showServiceMapScene() -> UIViewController {
        let serviceMapPopUpViewController = ServiceMapPopUpViewController()
        serviceMapPopUpViewController.modalPresentationStyle = .overFullScreen
        return serviceMapPopUpViewController
    }
}

extension SearchCountyCoordinator: SelectCountyViewModelDelegate {
    func goToShowVillageList(selectCountyData: String) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showVillageListScene(selectCountyData: selectCountyData), animated: true)
    }
    
    func popUpServiceMap() {
        guard let navigationController = navigationController else { return }
        navigationController.present(showServiceMapScene(), animated: false)
    }
}
