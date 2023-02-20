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
    var delegate: TownIntroduceViewModelDelegate?
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
        let townIntroViewModel = TownIntroduceViewModel(delegate: self,
                                                    townUseCase: townUseCase,
                                                    authUseCase: authUseCase,
                                                    cityCode: cityCode)
        return TownIntroduceViewController(viewModel: townIntroViewModel)
    }
 }

extension TownIntroCoordinator: TownIntroduceViewModelDelegate {
    
    func goToMap() {
        guard let navigationController = navigationController else {
            return
        }
        MapCoordinator(presentationStyle: .push(navigationController: navigationController), cityCode: cityCode).start()
    }
 }
