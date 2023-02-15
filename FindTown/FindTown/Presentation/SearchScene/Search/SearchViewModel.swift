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

protocol SearchViewModelDelegate {
    func goToShowVillageList(selectCountyData: String)
    func popUpServiceMap()
}

protocol SearchViewModelType {
    func goToShowVillageList(selectCountyData: String)
    func popUpServiceMap()
}

final class SearchViewModel: BaseViewModel {
    
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
    let delegate: SearchViewModelDelegate
    
    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.output.countyDataSource.onNext(County.allCases)
        self.output.searchFilterDataSource.accept([])
        
        self.input.selectedCounty
            .bind { [weak self] county in
                var dataSource = self?.output.searchFilterDataSource.value
                dataSource?.insert(county, at: 0)
                self?.output.searchFilterDataSource.accept(dataSource ?? [])
                self?.goToShowVillageList(selectCountyData: county)
            }
            .disposed(by: disposeBag)
        
        self.input.removedCounty
            .bind { [weak self] filter in
                var dataSource = self?.output.searchFilterDataSource.value
                if let index = dataSource?.firstIndex(where: {$0 == filter }) {
                    dataSource?.remove(at: index)
                }
                self?.output.searchFilterDataSource.accept(dataSource ?? [])
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

extension SearchViewModel: SearchViewModelType {
    func goToShowVillageList(selectCountyData: String) {
        delegate.goToShowVillageList(selectCountyData: selectCountyData)
    }
    func popUpServiceMap() {
        delegate.popUpServiceMap()
    }
}
