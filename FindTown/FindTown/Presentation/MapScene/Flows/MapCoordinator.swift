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
    
    func presentAddressSheet() {
        guard let navigationController = navigationController else { return }
        AddressSheetCoordinator(presentationStyle: .present(navigationController: navigationController, modalPresentationStyle: .overFullScreen),       parentCoordinator: self).start()
    }
    
    func setCityData(_ city: City) {
        guard let navigationController = navigationController else { return }
        if let mapViewController = navigationController.topViewController as? MapViewController {
            mapViewController.viewModel?.output.city.onNext(city)
        }
    }
}
