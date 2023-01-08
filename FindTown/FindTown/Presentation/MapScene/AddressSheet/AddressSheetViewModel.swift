//
//  AddressSheetViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/08.
//

import UIKit
import FindTownCore

protocol AddressSheetViewModelDelegate {
}

protocol AddressSheetViewModelType {
}

final class AddressSheetViewModel: BaseViewModel {
    let delegate: AddressSheetViewModelDelegate
    
    init(delegate: AddressSheetViewModelDelegate) {
        self.delegate = delegate
    }
}

extension AddressSheetViewModel: AddressSheetViewModelType {
    
}
