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
        let year = BehaviorSubject<Int>(value: 0)
        let month = BehaviorSubject<Int>(value: 1)
        
        let dongYearMonth = BehaviorSubject<DongYearMonthModel>(
            value: DongYearMonthModel(dong: "", year: 0, month: 1)
        )
        
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nextButtonEnabled = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupViewModelDelegate
    
    init(
        delegate: SignupViewModelDelegate
    ) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.nextButtonTrigger
            .withLatestFrom(input.dongYearMonth)
            .bind(onNext: setDongYearMonth)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.dong, input.year, input.month)
            .bind { [weak self] (dong, year, month) in
                self?.output.nextButtonEnabled.accept(true)
                let model = DongYearMonthModel(dong: dong, year: year, month: month)
                self?.input.dongYearMonth.onNext(model)
            }
            .disposed(by: disposeBag)
    }
    
    private func setDongYearMonth(dongYearMonth: DongYearMonthModel) {
        // 1. dongYearMonth 임시로 set
        print("dongYearMonth \(dongYearMonth)")
        
        if dongYearMonth.dong == "" {
            self.output.nextButtonEnabled.accept(false)
        } else {
            // 2. after goToTwonMood
            self.goToTownMood()
        }
    }
}

extension LocationAndYearsViewModel: LocationAndYearsViewModelType {
    
    func goToTownMood() {
        delegate.goToTownMood()
    }
}
