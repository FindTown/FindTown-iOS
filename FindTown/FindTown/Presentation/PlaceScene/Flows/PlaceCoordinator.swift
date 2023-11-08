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
        return PlaceViewController()
    }
}
