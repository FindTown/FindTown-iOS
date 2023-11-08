//
//  PlaceViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import Foundation

import FindTownCore

protocol PlaceViewModelDelegate {
    func presentAddressSheet()
}

protocol PlaceViewModelType {
    func presentAddressSheet()
}

final class PlaceViewModel: BaseViewModel {
    let delegate: PlaceViewModelDelegate
    
    init(delegate: PlaceViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
    }
}

extension PlaceViewModel: PlaceViewModelType {
    func presentAddressSheet() {
        delegate.presentAddressSheet()
    }
}
