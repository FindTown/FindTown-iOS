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
    func dismiss(_ city: City)
}

protocol AddressSheetViewModelType {
    func dismiss(_ city: City)
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
        .subscribe { [weak self] city in
            let code = CityCode(county: city.county, village: city.village)
            
            // 네트워크
            print(code?.description)
            
            self?.dismiss(city)
        }
        .disposed(by: disposeBag)
    }
}

extension AddressSheetViewModel: AddressSheetViewModelType {
    func dismiss(_ city: City) {
        self.delegate.dismiss(city)
    }
}
