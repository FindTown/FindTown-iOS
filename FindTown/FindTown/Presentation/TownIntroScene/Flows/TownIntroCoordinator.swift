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

    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }

    internal func initScene() -> UIViewController {
        let townIntroViewModel = TownIntroViewModel(delegate: self)
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
