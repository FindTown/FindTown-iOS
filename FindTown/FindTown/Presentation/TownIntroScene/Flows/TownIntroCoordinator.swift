//
//  TownIntroCoordinator.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/30.
//

import UIKit
import FindTownCore

final class TownIntroCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    let appDIContainer: AppDIContainer
    let cityCode: Int

    init(presentationStyle: PresentationStyle,
         appDIContainer: AppDIContainer,
         cityCode: Int) {
        
        self.presentationStyle = presentationStyle
        self.appDIContainer = appDIContainer
        self.cityCode = cityCode
    }

    internal func initScene() -> UIViewController {
        let townIntroViewModel = TownIntroduceViewModel(townUseCase: appDIContainer.townUseCase,
                                                        authUseCase: appDIContainer.authUseCase,
                                                        memeberUseCase: appDIContainer.memberUseCase,
                                                        cityCode: cityCode)
        return TownIntroduceViewController(viewModel: townIntroViewModel)
    }
 }
