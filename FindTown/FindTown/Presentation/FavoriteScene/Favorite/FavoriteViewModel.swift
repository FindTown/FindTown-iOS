//
//  Favorite1ViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import Foundation
import FindTownCore
import RxSwift

protocol FavoriteViewModelType {
    func goToLogin()
    func goToTownIntro()
}

protocol FavoriteViewModelDelegate {
    func goToLogin()
    func goToTownIntro()
}

enum FavoriteViewStatus {
    /// 로그인하지 않은 사용자인 경우
    case anonymous
    /// 찜한 동네가 없는 경우
    case isEmpty
    /// 찜한 동네가 있는 경우
    case isPresent
}

final class FavoriteViewModel: BaseViewModel {
    
    let delegate: FavoriteViewModelDelegate
    
    struct Input {
        let signUpButtonTrigger = PublishSubject<Void>()
        let townIntroButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let viewStatus = BehaviorSubject<FavoriteViewStatus>(value: .anonymous)
        let favoriteDataSource = BehaviorSubject<[townModelTest]>(value: [])
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
                self?.delegate.goToLogin()
            })
            .disposed(by: disposeBag)
        
        self.input.townIntroButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToTownIntro()
            })
            .disposed(by: disposeBag)
        
        self.output.favoriteDataSource.onNext(returnTownTestData())
        self.output.viewStatus.onNext(returnViewStatus())
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    
    func goToLogin() {
        delegate.goToLogin()
    }
    
    func goToTownIntro() {
        delegate.goToTownIntro()
    }
}

// 임시
struct townModelTest {
    let image: String
    let village: String
    let introduce: String
}

extension FavoriteViewModel {
    
    func returnViewStatus() -> FavoriteViewStatus {
        if UserDefaultsSetting.isAnonymous {
            return .anonymous
        } else {
            // 찜 API 호출
            return .isPresent
        }
    }
    
    func returnTownTestData() -> [townModelTest] {
        let demoTown1 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown2 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown3 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown4 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown5 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown6 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown7 = townModelTest(image: "map", village: "신림동", introduce: "자취생들이 많이 사는 동네")
        
        let towns = [demoTown1, demoTown2, demoTown3, demoTown4, demoTown5, demoTown6, demoTown7]
        return towns + towns
    }
}
