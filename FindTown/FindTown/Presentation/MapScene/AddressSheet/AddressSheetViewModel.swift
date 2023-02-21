//
//  AddressSheetViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2023/01/08.
//

import UIKit
import FindTownCore

import RxSwift

protocol AddressSheetViewModelDelegate {
    func dismiss(_ cityCode: Int)
}

protocol AddressSheetViewModelType {
    func dismiss(_ cityCode: Int)
}

final class AddressSheetViewModel: BaseViewModel {
    let delegate: AddressSheetViewModelDelegate
    
    struct Input {
        var selectedCity = PublishSubject<City>()
        var didTapCompleteButton = PublishSubject<Void>()
    }
    
    struct Output {
        var countyDataSource = BehaviorSubject<[County]>(value: [])
        var villageDataSource = BehaviorSubject<[City]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    
    init(delegate: AddressSheetViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.output.countyDataSource.onNext(County.allCases)
        
        self.input.didTapCompleteButton.withLatestFrom(self.input.selectedCity)
            .subscribe(onNext: { [weak self] city in
                guard let cityCode = CityCode(county: city.county, village: city.village) else {
                    return
                }
                self?.dismiss(cityCode.rawValue)
            })
            .disposed(by: disposeBag)
    }
}

extension AddressSheetViewModel: AddressSheetViewModelType {
    func dismiss(_ cityCode: Int) {
        self.delegate.dismiss(cityCode)
    }
}
