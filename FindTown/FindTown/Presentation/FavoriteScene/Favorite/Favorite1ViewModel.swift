//
//  Favorite1ViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import Foundation
import FindTownCore
import RxSwift

protocol Favorite1ViewModelType {
   func goToSignUp()
}

protocol FavoriteViewModelDelegate {
    func goToSignup()
}

enum FavoriteViewStatus {
    /// 로그인하지 않은 사용자인 경우
    case anonymous
    /// 찜한 동네가 없는 경우
    case isEmpty
    /// 찜한 동네가 있는 경우
    case isPresent
}

final class Favorite1ViewModel: BaseViewModel {
    
    let delegate: FavoriteViewModelDelegate
    
    struct Input {
        let signUpButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let viewStatus = BehaviorSubject<FavoriteViewStatus>(value: .anonymous)
        let favoriteDataSource = BehaviorSubject<[Store]>(value: [])
    }
    
    let output = Output()
    let input = Input()
    
    init(delegate: FavoriteViewModelDelegate) {
        self.delegate = delegate
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.signUpButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToSignup()
            })
            .disposed(by: disposeBag)
        
        self.output.favoriteDataSource.onNext(returnStoreTestData())
        self.output.viewStatus.onNext(returnViewStatus())
    }
}

extension Favorite1ViewModel: Favorite1ViewModelType {
    
    func goToSignUp() {
        delegate.goToSignup()
    }
}

extension Favorite1ViewModel {
    
    func returnViewStatus() -> FavoriteViewStatus {
        return .isEmpty
    }
    
    func returnStoreTestData() -> [Store] {
        let stores = [Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          ]
        return stores + stores + stores + stores
    }
}
