//
//  FilterSheetCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit

import FindTownCore

final class FilterSheetCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    var filterSheetType: FilterSheetType
    var filterDataSource: TempFilterModel
    weak var navigationController: UINavigationController?
    
    init(
        presentationStyle: PresentationStyle,
        filterSheetType: FilterSheetType,
        filterDataSource: TempFilterModel
    ) {
        self.presentationStyle = presentationStyle
        self.filterSheetType = filterSheetType
        self.filterDataSource = filterDataSource
    }
    
    internal func initScene() -> UIViewController {
        let addressSheetViewModel = FilterBottomSheetViewModel(delegate: self)
        return FilterBottonSheetViewController(viewModel: addressSheetViewModel,
                                               filterSheetType: self.filterSheetType,
                                               filterDataSource: self.filterDataSource)
    }
}

extension FilterSheetCoordinator: FilterBottomSheetViewModelDelegate {
    func dismiss(_ tempModel: TempFilterModel) {
        guard let navigationController = navigationController else { return }
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.dismissBottomSheet(tempModel)
        }
    }
}
