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
    func dismiss(_ filterModel: FilterModel)
}

protocol FilterBottomSheetViewModelType {
    func dismiss(_ filterModel: FilterModel)
}

final class FilterBottomSheetViewModel: BaseViewModel {
    
    struct Input {
        let infra = PublishSubject<String>()
        let traffic = PublishSubject<[String]>()
        let trafficIndexPath = PublishSubject<[IndexPath]>()
        let completeButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        let buttonsSelected = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    let delegate: FilterBottomSheetViewModelDelegate
    private var filterModel: FilterModel?
    
    init(delegate: FilterBottomSheetViewModelDelegate) {
        self.delegate = delegate
        self.filterModel = FilterModel()
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.output.trafficDataSource.onNext(Traffic.allCases)
        
        self.input.completeButtonTrigger
            .bind { [weak self] in
                guard let filterModel = self?.filterModel else { return }
                self?.dismiss(filterModel)
            }
            .disposed(by: disposeBag)
        
        self.input.infra
            .map { return (data: $0, isSelected: $0 != "")}
            .bind { [weak self] infra in
                self?.filterModel?.infra = infra.data
                self?.output.buttonsSelected.accept(infra.isSelected)
            }
            .disposed(by: disposeBag)
        
        self.input.traffic
            .map { return (data: $0, isSelected: $0.count != 0)}
            .bind { [weak self] traffic in
                self?.filterModel?.traffic = traffic.data
                self?.output.buttonsSelected.accept(traffic.isSelected)
            }
            .disposed(by: disposeBag)
        
        self.input.trafficIndexPath
            .bind { [weak self] in
                self?.filterModel?.trafficIndexPath = $0
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.input.infra.map { $0 != "" },
            self.input.traffic.map { $0.count != 0 }
        )
        .bind { [weak self] infraSelected, trafficSelected in
            let isEitherSelected = infraSelected || trafficSelected
            self?.output.buttonsSelected.accept(isEitherSelected)
        }
        .disposed(by: disposeBag)
    }
}

extension FilterBottomSheetViewModel: FilterBottomSheetViewModelType {
    func dismiss(_ inputData: FilterModel) {
        self.delegate.dismiss(inputData)
    }
}
