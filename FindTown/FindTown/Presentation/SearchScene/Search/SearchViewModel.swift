//
//  SearchViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/20.
//

import Foundation
import FindTownCore

import RxSwift
import RxRelay

protocol SearchViewModelDelegate {
    func goToShowVillageList(searchType: SearchType, data: String)
    func popUpServiceMap()
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
    func goToAuth()
}

protocol SearchViewModelType {
    func goToShowVillageList(searchType: SearchType, data: String)
    func popUpServiceMap()
}

final class SearchViewModel: BaseViewModel {
    
    struct Input {
        let selectedCounty = PublishSubject<String>()
        let removedCounty =  PublishSubject<String>()
        let allDeleteTrigger = PublishSubject<Void>()
        let serviceMapPopUpTrigger = PublishSubject<Void>()
        let searchedData = PublishSubject<String>()
    }
    
    struct Output {
        var searchFilterDataSource = BehaviorRelay<[String]>(value: [])
        var countyDataSource = BehaviorSubject<[County]>(value: [])
        var searchedDataSource = BehaviorSubject<[Search]>(value: [])
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
//                var dataSource = self?.output.searchFilterDataSource.value
//                dataSource?.insert(county, at: 0)
//                self?.output.searchFilterDataSource.accept(dataSource ?? [])
                self?.goToShowVillageList(searchType: .sgg, data: county)
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
                UserDefaultsSetting.searchedDongList = []
                self?.output.searchedDataSource.onNext([])
            }
            .disposed(by: disposeBag)
        
        self.input.serviceMapPopUpTrigger
            .bind { [weak self] in
                self?.popUpServiceMap()
            }
            .disposed(by: disposeBag)
        
        self.input.searchedData
            .bind(onNext: { [weak self] data in
                self?.goToShowVillageList(searchType: .adm, data: data)
                self?.addSearchedData(data)
            })
            .disposed(by: disposeBag)
        
        getSearchedData()
    }
}

extension SearchViewModel {
    func getSearchedData() {
        let sortedData = UserDefaultsSetting.searchedDongList
                                            .sorted(by: { $0.time < $1.time})
        self.output.searchedDataSource.onNext(sortedData)
    }
    
    func addSearchedData(_ data: String) {
        var searchedData = UserDefaultsSetting.searchedDongList
        searchedData.append(Search(data: data, time: .now))
        
        if searchedData.count >= 10 {
            searchedData.sort(by: { $0.time < $1.time})
            searchedData.removeLast()
        }
    
        self.output.searchedDataSource.onNext(searchedData)
        UserDefaultsSetting.searchedDongList = searchedData
    }
}

extension SearchViewModel: SearchViewModelType {
    func goToShowVillageList(searchType: SearchType, data: String) {
        delegate.goToShowVillageList(searchType: searchType, data: data)
    }
    
    func popUpServiceMap() {
        delegate.popUpServiceMap()
    }
}

extension SearchViewModel: SearchedDongCollectionViewCellDelegate {
    func deletedDongData(data: Search) {
        let dongList = UserDefaultsSetting.searchedDongList.filter { $0 != data }
        UserDefaultsSetting.searchedDongList = dongList
        getSearchedData()
    }
}
