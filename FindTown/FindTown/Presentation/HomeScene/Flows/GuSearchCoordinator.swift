//
//  GuSearchCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import UIKit

import FindTownCore

final class GuSearchCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let searchViewModel = GuSelectViewModel(delegate: self)
        let searchViewController = GuSelectViewController(viewModel: searchViewModel)
        return searchViewController
    }
    
    internal func guSelectDongScene(selectGuData: String) -> UIViewController {
        let guSelectDongViewModel = GuSelectDongViewModel()
        let guSelectDongViewController = GuSelectDongViewController(viewModel: guSelectDongViewModel,
                                                                    selectGuData: selectGuData)
        return guSelectDongViewController
    }
}

extension GuSearchCoordinator: GuSelectViewModelDelegate {
    func goToGuSelectDong(selectGuData: String) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(guSelectDongScene(selectGuData: selectGuData), animated: true)
    }
}
