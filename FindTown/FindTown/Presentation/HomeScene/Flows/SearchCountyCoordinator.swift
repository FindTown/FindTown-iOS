//
//  GuSearchCoordinator.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import UIKit

import FindTownCore

final class SearchCountyCoordinator: FlowCoordinator {
    
    var presentationStyle: PresentationStyle
    weak var navigationController: UINavigationController?
    
    init(presentationStyle: PresentationStyle) {
        self.presentationStyle = presentationStyle
    }
    
    internal func initScene() -> UIViewController {
        let selectCountyViewModel = SelectCountyViewModel(delegate: self)
        let selectCountyViewController = SelectCountyViewController(viewModel: selectCountyViewModel)
        return selectCountyViewController
    }
    
    internal func showDongListScene(selectCountyData: String) -> UIViewController {
        let showDongListViewModel = ShowDongListViewModel(selectCountyData: selectCountyData)
        let showDongListViewController = ShowDongListViewController(viewModel: showDongListViewModel)
        return showDongListViewController
    }
}

extension SearchCountyCoordinator: SelectCountyViewModelDelegate {
    func goToShowDongList(selectCountyData: String) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(showDongListScene(selectCountyData: selectCountyData), animated: true)
    }
}
