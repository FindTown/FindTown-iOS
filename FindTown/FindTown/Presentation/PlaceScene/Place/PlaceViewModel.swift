//
//  PlaceViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/11/08.
//

import Foundation

import FindTownCore

import RxSwift

protocol PlaceViewModelDelegate {
    func presentAddressSheet()
}

protocol PlaceViewModelType {
    func presentAddressSheet()
}

final class PlaceViewModel: BaseViewModel {
    
    struct Output {
        let themeDataSource = BehaviorSubject<[ThemaCategory]>(value: ThemaCategory.allCases)
    }
    
    let delegate: PlaceViewModelDelegate
    let output = Output()
    
    init(delegate: PlaceViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
//        self.output.themeDataSource.onNext(ThemaCategory.allCases)
    }
}

extension PlaceViewModel: PlaceViewModelType {
    func presentAddressSheet() {
        delegate.presentAddressSheet()
    }
}
