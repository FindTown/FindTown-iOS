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
    func dismiss(_ tempModel: FilterModel)
}

protocol FilterBottomSheetViewModelType {
    func dismiss(_ tempModel: FilterModel)
}

final class FilterBottomSheetViewModel: BaseViewModel {
    
    struct Input {
        let infra = PublishSubject<String>()
        let traffic = PublishSubject<[String]>()
        let completeButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        let buttonsSelected = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    let delegate: FilterBottomSheetViewModelDelegate
    private var tempFilterModel: FilterModel?
    
    init(delegate: FilterBottomSheetViewModelDelegate) {
        self.delegate = delegate
        self.tempFilterModel = FilterModel()
        
        super.init()
        self.bind()
    }
    
    func bind() {

        self.output.trafficDataSource.onNext(Traffic.allCases)
        
        self.input.completeButtonTrigger
            .bind { [weak self] in
                guard let tempFilterModel = self?.tempFilterModel else { return }
                self?.dismiss(tempFilterModel)
            }
            .disposed(by: disposeBag)
        
        self.input.infra
            .map { return ($0, $0 != "")}
            .bind { [weak self] in
                self?.tempFilterModel?.infra = $0.0
                self?.output.buttonsSelected.accept($0.1)
            }
            .disposed(by: disposeBag)
        
        self.input.traffic
            .map { return ($0, $0.count != 0) }
            .bind { [weak self] in
                self?.tempFilterModel?.traffic = $0.0
                self?.output.buttonsSelected.accept($0.1)
            }
            .disposed(by: disposeBag)
    }
}

extension FilterBottomSheetViewModel: FilterBottomSheetViewModelType {
    func dismiss(_ inputData: FilterModel) {
        self.delegate.dismiss(inputData)
    }
}
