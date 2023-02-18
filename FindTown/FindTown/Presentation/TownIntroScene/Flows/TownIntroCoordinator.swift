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
    var delegate: TownIntroViewModelDelegate?
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    let cityCode: Int

    init(presentationStyle: PresentationStyle,
         townUseCase: TownUseCase,
         authUseCase: AuthUseCase,
         cityCode: Int) {
        
        self.presentationStyle = presentationStyle
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.cityCode = cityCode
    }

    internal func initScene() -> UIViewController {
        let townIntroViewModel = TownIntroViewModel(delegate: self,
                                                    townUseCase: townUseCase,
                                                    authUseCase: authUseCase,
                                                    cityCode: cityCode)
        return TownIntroViewController(viewModel: townIntroViewModel)
    }
 }

extension TownIntroCoordinator: TownIntroViewModelDelegate {
    
    func goToMap() {
        guard let navigationController = navigationController else {
            return
        }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController)).start()
    }
 }
