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

protocol FavoriteTownViewModelType {
    func goToAgreePolicy(_ signupUserModel: SignupUserModel)
}

final class FavoriteTownViewModel: BaseViewModel {
    
    struct Input {
        let county = BehaviorSubject<County?>(value: nil)
        let village = BehaviorSubject<Village?>(value: nil)
//
        let cityCode = PublishSubject<Int>()
        let nextButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let buttonsSelected = BehaviorRelay<Bool>(value: false)
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
            .withLatestFrom(input.cityCode)
            .bind(onNext: setFavorite)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.county, input.village)
            .bind { [weak self] (county, village) in
                if let county = county,
                      let village = village,
                      let cityCode = CityCode(county: county, village: village)?.rawValue {
                    self?.input.cityCode.onNext(cityCode)
                    self?.output.buttonsSelected.accept(true)
                } else {
                    self?.output.buttonsSelected.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setFavorite(cityCode: Int) {
        signupUserModel.objectId = cityCode
        
        self.goToAgreePolicy(signupUserModel)
    }
}

extension FavoriteTownViewModel: FavoriteTownViewModelType {
    
    func goToAgreePolicy(_ signupUserModel: SignupUserModel) {
        delegate.goToAgreePolicy(signupUserModel)
    }
}
