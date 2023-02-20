//
//  AddressSheetCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/08.
//

import UIKit
import FindTownCore

final class AddressSheetCoordinator: FlowCoordinator {

    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    var parentCoordinator: FlowCoordinator
    
    init(presentationStyle: PresentationStyle,
         parentCoordinator: FlowCoordinator) {
        self.presentationStyle = presentationStyle
        self.parentCoordinator = parentCoordinator
    }
    
    internal func initScene() -> UIViewController {
        let addressSheetViewModel = AddressSheetViewModel(delegate: self)
        return AddressSheetViewController(viewModel: addressSheetViewModel)
    }
    
}

extension AddressSheetCoordinator: AddressSheetViewModelDelegate {
    func dismiss(_ cityCode: Int) {
        guard let navigationController = navigationController else { return }
        
        if let addressSheetViewController = navigationController.visibleViewController as? AddressSheetViewController {
            addressSheetViewController.setBottomSheetStatus(to: .hide)
        
            if let mapCoordinator = parentCoordinator as? MapCoordinator {
                mapCoordinator.setCityData(cityCode)
            }
        }
        
    }
}
