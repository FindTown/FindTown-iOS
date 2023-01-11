//
//  FavoriteViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/09.
//

import Foundation

import RxSwift
import RxRelay
import FindTownCore

protocol FavoriteViewModelType {
    func goToAgreePolicy()
}

struct JachiguDong {
    let jachigu: String
    let dong: String
}

final class FavoriteViewModel: BaseViewModel {
    
    struct Input {
        let jachigu = BehaviorSubject<String>(value: "자치구")
        let dong = BehaviorSubject<String>(value: "동")
        
        let jachiguDong = PublishSubject<JachiguDong>()
        
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let buttonsSelected = BehaviorRelay<Bool>(value: false)
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
            .withLatestFrom(input.jachiguDong)
            .bind(onNext: setFavorite)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.jachigu, input.dong)
            .map { (jachigu, dong) in
                self.input.jachiguDong.onNext(JachiguDong(jachigu: jachigu, dong: dong))
                return (jachigu != "자치구" && dong != "동")
            }
            .bind { [weak self] in
                self?.output.buttonsSelected.accept($0)
            }
            .disposed(by: disposeBag)
    }
    
    private func setFavorite(jachiguDong: JachiguDong) {
        // 1. favorite 임시로 set
        print("jachigu \(jachiguDong.jachigu)")
        print("dong \(jachiguDong.dong)")
        
        // 2. after goToLocationAndYears
        self.goToAgreePolicy()
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    
    func goToAgreePolicy() {
        delegate.goToAgreePolicy()
    }
}
