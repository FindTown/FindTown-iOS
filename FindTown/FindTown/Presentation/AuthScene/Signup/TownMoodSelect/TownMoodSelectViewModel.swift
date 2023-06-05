//
//  TownMoodSelectViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2023/06/05.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol TownMoodSelectViewModelType {
    func goToFavorite(_ signupUserModel: SignupUserModel)
}

final class TownMoodSelectViewModel: BaseViewModel {
    
    struct Input {
        let selectedMoodItems = PublishSubject<[TownMood]>()
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
            .withLatestFrom(input.selectedMoodItems)
            .bind(onNext: setMoodItems)
            .disposed(by: disposeBag)
        
        self.input.selectedMoodItems
            .bind { [weak self] items in
                self?.output.buttonsSelected.accept(items.count < 3 ? false : true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setMoodItems(itmes: [TownMood]) {
      signupUserModel.moods = itmes.map { $0.description }
      self.goToFavorite(signupUserModel)
    }
}

extension TownMoodSelectViewModel: TownMoodSelectViewModelType {
    
    func goToFavorite(_ signupUserModel: SignupUserModel) {
        delegate.goToFavorite(signupUserModel)
    }
}

