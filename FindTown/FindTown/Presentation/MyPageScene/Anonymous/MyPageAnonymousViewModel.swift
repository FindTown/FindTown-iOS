//
//  MyPageAnonymousViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/02.
//

import Foundation

import FindTownCore
import RxSwift

protocol MyPageAnonymousViewModelType {
    func goToAuth()
}

final class MyPageAnonymousViewModel: BaseViewModel {
    
    struct Input {
        let goToLoginTrigger = PublishSubject<Void>()
    }
    
    struct Output { }
    
    let input = Input()
    let output = Output()
    let delegate: MyPageViewModelDelegate
    
    init(
        delegate: MyPageViewModelDelegate
    ) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.input.goToLoginTrigger
            .bind { [weak self] in
                self?.goToAuth()
            }
            .disposed(by: disposeBag)
    }
}

extension MyPageAnonymousViewModel: MyPageAnonymousViewModelType {
    func goToAuth() {
        delegate.goToAuth()
    }
}
