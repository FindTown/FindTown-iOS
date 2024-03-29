//
//  SignUpSecondViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2022/12/31.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol TownMoodViewModelType {
    func goToTownMoodSelect(_ signupUserModel: SignupUserModel)
}

final class TownMoodViewModel: BaseViewModel {
    
    struct Input {
        let townLikeText = PublishSubject<String>()
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let buttonsSelected = PublishRelay<Bool>()
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
            .withLatestFrom(input.townLikeText)
            .bind(onNext: settownLikeText)
            .disposed(by: disposeBag)
        
        self.input.townLikeText
            .bind { [weak self] inputText in
                self?.output.buttonsSelected.accept(inputText.count < 10 ? false : true)
            }
            .disposed(by: disposeBag)
    }
    
    private func settownLikeText(townLikeText: String) {
        signupUserModel.resident.residentReview = townLikeText
        self.goToTownMoodSelect(signupUserModel)
    }
}

extension TownMoodViewModel: TownMoodViewModelType {
    
    func goToTownMoodSelect(_ signupUserModel: SignupUserModel) {
        delegate.goToTownMoodSelect(signupUserModel)
    }
}
