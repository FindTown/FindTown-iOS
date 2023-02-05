//
//  SearchViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import UIKit
import FindTownCore

import RxSwift
import RxRelay

protocol SelectCountyViewModelDelegate {
    func goToShowVillageList(selectCountyData: String)
    func popUpServiceMap()
}

protocol SelectCountyViewModelType {
    func goToShowVillageList(selectCountyData: String)
    func popUpServiceMap()
}

final class SelectCountyViewModel: BaseViewModel {
    
    struct Input {
        let selectedCounty = PublishSubject<String>()
        let removedCounty =  PublishSubject<String>()
        let allDeleteTrigger = PublishSubject<Void>()
        let serviceMapPopUpTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        var searchFilterDataSource = BehaviorRelay<[String]>(value: [])
        var countyDataSource = BehaviorSubject<[County]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let delegate: SelectCountyViewModelDelegate
    
    init(delegate: SelectCountyViewModelDelegate) {
        self.delegate = delegate
    
        super.init()
        self.bind()
    }
    
    func bind() {
        self.output.countyDataSource.onNext(County.allCases)
        self.output.searchFilterDataSource.accept([])
        
        self.input.selectedCounty
            .bind { [weak self] in
                var tempDataSource = self?.output.searchFilterDataSource.value
                tempDataSource?.insert($0, at: 0)
                self?.output.searchFilterDataSource.accept(tempDataSource ?? [])
                self?.goToShowVillageList(selectCountyData: $0)
            }
            .disposed(by: disposeBag)
        
        self.input.removedCounty
            .bind { [weak self] filter in
                var tempDataSource = self?.output.searchFilterDataSource.value
                if let index = tempDataSource?.firstIndex(where: {$0 == filter }) {
                    tempDataSource?.remove(at: index)
                }
                self?.output.searchFilterDataSource.accept(tempDataSource ?? [])
            }
            .disposed(by: disposeBag)
        
        self.input.allDeleteTrigger
            .bind { [weak self] in
                self?.output.searchFilterDataSource.accept([])
            }
            .disposed(by: disposeBag)
        
        self.input.serviceMapPopUpTrigger
            .bind { [weak self] in
                self?.popUpServiceMap()
            }
            .disposed(by: disposeBag)
    }
}

extension SelectCountyViewModel: SelectCountyViewModelType {
    func goToShowVillageList(selectCountyData: String) {
        delegate.goToShowVillageList(selectCountyData: selectCountyData)
    }
    func popUpServiceMap() {
        delegate.popUpServiceMap()
    }
}
