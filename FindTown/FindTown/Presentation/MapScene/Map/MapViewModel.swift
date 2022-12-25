//
//  MapViewMode.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation
import FindTownCore

protocol MapViewModelDelegate {
    func gotoIntroduce()
    func presentAddressPopup()
}

protocol MapViewModelType {
    func gotoIntroduce()
    func presentAddressPopup()
}

final class MapViewModel: BaseViewModel {
    let delegate: MapViewModelDelegate
    
    init(delegate: MapViewModelDelegate) {
        self.delegate = delegate
    }
}

extension MapViewModel: MapViewModelType {
    func gotoIntroduce() {
        delegate.gotoIntroduce()
    }
    
    func presentAddressPopup() {
        delegate.presentAddressPopup()
    }
    
}
