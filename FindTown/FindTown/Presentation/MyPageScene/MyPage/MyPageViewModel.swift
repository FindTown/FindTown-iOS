//
//  MyPageViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/31.
//

import UIKit

import FindTownCore
import RxSwift
import RxRelay

protocol MyPageViewModelDelegate {
    func goToLogin()
    func goToChangeNickname()
    func goToMyTownReview()
    func popUpSignout()
    func popUpWithDraw()
}

protocol MyPageViewModelType {
    func goToChangeNickname()
    func goToMyTownReview()
    func popUpSignout()
    func popUpWithDraw()
}

final class MyPageViewModel: BaseViewModel {
    
    struct Input {
        let changeNicknameButtonTrigger = PublishSubject<Void>()
        let reviewButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        
    }
    
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
        self.input.changeNicknameButtonTrigger
            .bind { [weak self] in
                self?.goToChangeNickname()
            }
            .disposed(by: disposeBag)
        
        self.input.reviewButtonTrigger
            .bind {[weak self] in
                self?.goToMyTownReview()
            }
            .disposed(by: disposeBag)
    }
}

extension MyPageViewModel: MyPageViewModelType {
    func goToChangeNickname() {
        delegate.goToChangeNickname()
    }
    
    func goToMyTownReview() {
        delegate.goToMyTownReview()
    }
    
    func popUpSignout() {
        delegate.popUpSignout()
    }
    
    func popUpWithDraw() {
        delegate.popUpWithDraw()
    }
}
