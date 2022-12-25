//
//  HomeViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation
import FindTownCore

protocol HomeViewModelDelegate {
    func push()
    func present()
    func pop()
    func dismiss()
    func setViewController()
}

protocol HomeViewModelType {
    func push()
    func present()
    func pop()
    func dismiss()
    func setViewController()
}

final class HomeViewModel: BaseViewModel {
    let delegate: HomeViewModelDelegate
    
    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
}

extension HomeViewModel: HomeViewModelType {
    
    func push() {
        delegate.push()
    }
    
    func present() {
        delegate.present()
    }
    
    func pop() {
        delegate.pop()
    }
    
    func dismiss() {
        delegate.dismiss()
    }
    
    func setViewController() {
        delegate.setViewController()
    }
}
