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
    let memberUseCase: MemberUseCase
    let cityCode: Int

    init(presentationStyle: PresentationStyle,
         townUseCase: TownUseCase,
         authUseCase: AuthUseCase,
         memberUseCase: MemberUseCase,
         cityCode: Int) {
        
        self.presentationStyle = presentationStyle
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        self.cityCode = cityCode
    }

    internal func initScene() -> UIViewController {
        let townIntroViewModel = TownIntroduceViewModel(delegate: self,
                                                    townUseCase: townUseCase,
                                                    authUseCase: authUseCase,
                                                    memeberUseCase: memberUseCase,
                                                    cityCode: cityCode)
        return TownIntroduceViewController(viewModel: townIntroViewModel)
    }
 }

extension TownIntroCoordinator: TownIntroduceViewModelDelegate {
    
    func goToMap() {
        guard let navigationController = navigationController else {
            return
        }
        // isAnonymous 임시
        MapCoordinator(presentationStyle: .push(navigationController: navigationController), isAnonymous: false).start()
    }
 }
