//
//  MapCoordinator.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import UIKit
import FindTownCore

final class MapCoordinator: FlowCoordinator {

    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let mapViewModel = MapViewModel(delegate: self)
        return MapViewController(viewModel: mapViewModel)
    }
    
}

extension MapCoordinator: MapViewModelDelegate {
    
    func gotoIntroduce() {
        
    }
    
    func presentAddressPopup() {
        
    }
    
}
