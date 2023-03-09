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
    let appDIContainer: AppDIContainer
    let mapTransition: MapTransition
    let cityCode: Int?
    
    init(presentationStyle: PresentationStyle,
         cityCode: Int?,
         mapTransition: MapTransition,
         appDIContainer: AppDIContainer) {
        self.presentationStyle = presentationStyle
        self.cityCode = cityCode
        self.mapTransition = mapTransition
        self.appDIContainer = appDIContainer
    }
    
    internal func initScene() -> UIViewController {
        let mapViewModel = MapViewModel(delegate: self,
                                        authUseCase: appDIContainer.authUseCase,
                                        mapUseCase: appDIContainer.mapUseCase,
                                        memberUseCase: appDIContainer.memberUseCase,
                                        cityCode: cityCode)
        return MapViewController(viewModel: mapViewModel, mapTransition: mapTransition)
    }
    
    internal func informationUpdateScene() -> UIViewController {
        let informationUpdateViewController = BaseWebViewController(webViewTitle: "정보 수정 요청", url: "https://docs.google.com/forms/d/e/1FAIpQLSejCcnZ_TFvlMRaYjgxUUneah1cgXjRwA0t_NrMKpiSNMYZrw/viewform")
        informationUpdateViewController.hidesBottomBarWhenPushed = true
        return informationUpdateViewController
    }
    
}

extension MapCoordinator: MapViewModelDelegate {
    
    func gotoIntroduce(cityCode: Int) {
        guard let navigationController = navigationController else { return }
        TownIntroCoordinator(presentationStyle: .push(navigationController: navigationController),
                             appDIContainer: appDIContainer,
                             cityCode: cityCode).start()
    }
    
    func presentAddressSheet() {
        guard let navigationController = navigationController else { return }
        AddressSheetCoordinator(presentationStyle: .present(navigationController: navigationController,
                                                            modalPresentationStyle: .overFullScreen),
                                parentCoordinator: self).start()
    }
    
    func presentInformationUpdateScene() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(informationUpdateScene(), animated: true)
    }
    
    func setCityData(_ city: Int) {
        guard let navigationController = navigationController else { return }
        if let mapViewController = navigationController.topViewController as? MapViewController {
            mapViewController.viewModel?.setCity(cityCode: city)
        }
    }
}
