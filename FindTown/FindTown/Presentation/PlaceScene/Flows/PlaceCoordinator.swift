//
//  PlaceCoordinator.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import UIKit

import FindTownCore

final class PlaceCoordinator: FlowCoordinator {
    
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
        let searchViewModel = PlaceViewModel(delegate: self)
        let searchViewController = PlaceViewController(viewModel: searchViewModel)
        return searchViewController
    }
}

extension PlaceCoordinator: PlaceViewModelDelegate {
    func presentAddressSheet() {
        guard let navigationController = navigationController else { return }
        AddressSheetCoordinator(
            presentationStyle: .present(
                navigationController: navigationController,
                modalPresentationStyle: .overFullScreen),
            parentCoordinator: self
        ).start()
    }
}
