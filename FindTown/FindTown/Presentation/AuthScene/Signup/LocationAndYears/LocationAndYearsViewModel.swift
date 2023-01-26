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
    func goToTownMood(_ signupUserModel: SignupUserModel)
}

final class LocationAndYearsViewModel: BaseViewModel {
    
    struct Input {
        let address = PublishSubject<String>()
        let year = BehaviorSubject<Int>(value: 0)
        let month = BehaviorSubject<Int>(value: 1)
        
        let dongYearMonth = BehaviorSubject<DongYearMonth>(
            value: DongYearMonth(dong: "", year: 0, month: 1)
        )
        
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nextButtonEnabled = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    let delegate: SignupViewModelDelegate
    var signupUserModel: SignupUserModel
    
    init(
        delegate: SignupViewModelDelegate,
        signupUserModel: SignupUserModel
    ) {
        self.delegate = delegate
        self.signupUserModel = signupUserModel
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.nextButtonTrigger
            .withLatestFrom(input.dongYearMonth)
            .bind(onNext: setDongYearMonth)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.address, input.year, input.month)
            .bind { [weak self] (address, year, month) in
                self?.output.nextButtonEnabled.accept(true)
                let model = DongYearMonth(dong: address, year: year, month: month)
                self?.input.dongYearMonth.onNext(model)
            }
            .disposed(by: disposeBag)
    }
    
    private func setDongYearMonth(dongYearMonth: DongYearMonth) {

        // TODO: address
        signupUserModel.resident.residentYear = dongYearMonth.year
        signupUserModel.resident.residentMonth = dongYearMonth.month
        signupUserModel.resident.residentAddress = dongYearMonth.dong
        
        if dongYearMonth.dong == "" {
            self.output.nextButtonEnabled.accept(false)
        } else {
            self.goToTownMood(signupUserModel)
        }
    }
}

extension LocationAndYearsViewModel: LocationAndYearsViewModelType {
    
    func goToTownMood(_ signupUserModel: SignupUserModel) {
        delegate.goToTownMood(signupUserModel)
    }
}
