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

protocol GuSelectViewModelDelegate {
    func goToGuSelectDong(selectGuData: String)
}

protocol GuSelectViewModelType {
    func goToGuSelectDong(selectGuData: String)
}

final class GuSelectViewModel: BaseViewModel {
    
    struct Input {
        let selectedCounty = PublishSubject<County>()
        let removedCounty =  PublishSubject<String>()
        let allDeleteTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        var searchFilterDataSource = BehaviorRelay<[String]>(value: [])
        var countyDataSource = BehaviorSubject<[County]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let delegate: GuSelectViewModelDelegate
    
    init(delegate: GuSelectViewModelDelegate) {
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
                tempDataSource?.insert($0.rawValue, at: 0)
                self?.output.searchFilterDataSource.accept(tempDataSource ?? [])
                self?.goToGuSelectDong(selectGuData: $0.rawValue)
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
    }
}

extension GuSelectViewModel: GuSelectViewModelType {
    func goToGuSelectDong(selectGuData: String) {
        delegate.goToGuSelectDong(selectGuData: selectGuData)
    }
}
