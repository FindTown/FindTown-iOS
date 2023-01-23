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
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let addressSheetViewModel = FilterBottomSheetViewModel(delegate: self)
        return FilterBottonSheetViewController(viewModel: addressSheetViewModel)
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
