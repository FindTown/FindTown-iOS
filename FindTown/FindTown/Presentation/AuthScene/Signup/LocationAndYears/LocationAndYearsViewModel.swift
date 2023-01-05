//
//  SignUpFirstInfoViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/30.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol LocationAndYearsViewModelType {
    func goToTownMood()
}

// 추후 수정
struct DongYearMonthModel {
    let dong: String
    let year: Int
    let month: Int
}

final class LocationAndYearsViewModel: BaseViewModel {
    
    struct Input {
        let dong = PublishSubject<String>()
        let year = PublishSubject<Int>()
        let month = PublishSubject<Int>()
        
        let dongYearMonth = BehaviorSubject<DongYearMonthModel>(
            value: DongYearMonthModel(dong: "", year: 0, month: 1)
        )
        
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let buttonsSelected = PublishRelay<Void>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupCoordinatorDelegate
    
    init(
        delegate: SignupCoordinatorDelegate
    ) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.dong
            .map { _ in }
            .bind(to: self.output.buttonsSelected)
            .disposed(by: disposeBag)
        
        self.input.nextButtonTrigger
            .withLatestFrom(input.dongYearMonth)
            .bind(onNext: setDongYearMonth)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.dong, input.year, input.month)
            .map { (dong, year, month) in
                return DongYearMonthModel(dong: dong, year: year, month: month)
            }
            .bind(to: input.dongYearMonth)
            .disposed(by: disposeBag)
    }
    
    private func setDongYearMonth(dongYearMonth: DongYearMonthModel) {
        // 1. dongYearMonth 임시로 set
        print("dongYearMonth \(dongYearMonth)")
        
        // 2. after goToTwonMood
        self.goToTownMood()
    }
}

extension LocationAndYearsViewModel: LocationAndYearsViewModelType {
    
    func goToTownMood() {
        delegate.goToTownMood()
    }
}
