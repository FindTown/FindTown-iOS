//
//  FilterBottomSheetViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/16.
//

import UIKit
import FindTownCore

import RxSwift
import RxRelay

protocol FilterBottomSheetViewModelDelegate {
    func dismiss(_ tempModel: String)
}

protocol FilterBottomSheetViewModelType {
    func dismiss(_ tempModel: String)
}

final class FilterBottomSheetViewModel: BaseViewModel {
    let delegate: FilterBottomSheetViewModelDelegate
    
    struct Input {
        let infra = PublishSubject<String>()
        let traffic = PublishSubject<[IndexPath]>()
        let completeButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        let buttonsSelected = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(delegate: FilterBottomSheetViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.output.trafficDataSource.onNext(Traffic.allCases)
        
        self.input.completeButtonTrigger
            .bind { [weak self] in
                self?.dismiss("")
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.infra, input.traffic)
            .map { (infra, traffic) in
                return (infra != "" && traffic.count == 3)
            }
            .bind { [weak self] in
                self?.output.buttonsSelected.accept($0)
            }
            .disposed(by: disposeBag)
    }
}

extension FilterBottomSheetViewModel: FilterBottomSheetViewModelType {
    func dismiss(_ tempModel: String) {
        self.delegate.dismiss("tempModel")
    }
}
