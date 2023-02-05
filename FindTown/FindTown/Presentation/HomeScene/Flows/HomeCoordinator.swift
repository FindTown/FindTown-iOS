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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let homeViewModel = HomeViewModel(delegate: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        return homeViewController
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    
    func goToFilterBottomSheet(filterSheetType: FilterSheetType, filterDataSource: TempFilterModel) {
        guard let navigationController = navigationController else { return }
        FilterSheetCoordinator(presentationStyle: .present(navigationController: navigationController,
                                                           modalPresentationStyle: .overFullScreen),
                               filterSheetType: filterSheetType,
                               filterDataSource: filterDataSource).start()
    }
    
    func goToGuSearchView() {
        guard let navigationController = navigationController else { return }
        SearchCountyCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
}
