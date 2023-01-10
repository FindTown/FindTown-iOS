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
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let addressSheetViewModel = AddressSheetViewModel(delegate: self)
        return AddressSheetViewController(viewModel: addressSheetViewModel)
    }
    
}

extension AddressSheetCoordinator: AddressSheetViewModelDelegate {
    func dismiss(_ city: City) {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true) 
    }
}
