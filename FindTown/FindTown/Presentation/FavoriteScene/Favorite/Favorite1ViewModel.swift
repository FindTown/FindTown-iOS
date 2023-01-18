//
//  Favorite1ViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import Foundation
import FindTownCore
import RxSwift

protocol Favorite1ViewModelDelegate {

}

final class Favorite1ViewModel: BaseViewModel {
    let delegate: Favorite1ViewModelDelegate
    
    struct Output {
        let viewStatus = BehaviorSubject<favoriteViewStatus>(value: .isEmpty)
    }
    
    let output = Output()
    
    init(delegate: Favorite1ViewModelDelegate) {
        self.delegate = delegate
        super.init()
        self.bind()
    }
    
    func bind() {

    }
}
