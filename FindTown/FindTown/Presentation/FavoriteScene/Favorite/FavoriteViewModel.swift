//
//  Favorite1ViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/18.
//

import UIKit
import Foundation
import FindTownCore
import RxSwift

protocol FavoriteViewModelType {
    func goToSignUp()
    func goToTownIntro(cityCode: Int)
}

protocol FavoriteViewModelDelegate {
    func goToSignup()
    func goToTownIntro(cityCode: Int)
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
        let townIntroButtonTrigger = PublishSubject<Int>()
    }
    
    struct Output {
        let viewStatus = BehaviorSubject<FavoriteViewStatus>(value: .anonymous)
        let favoriteDataSource = BehaviorSubject<[TownTableModel]>(value: [])
    }
    
    let output = Output()
    let input = Input()
    
    // MARK: - UseCase
    
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    
    init(delegate: FavoriteViewModelDelegate, townUseCase: TownUseCase, authUseCsae: AuthUseCase) {
        self.delegate = delegate
        self.townUseCase = townUseCase
        self.authUseCase = authUseCsae
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.signUpButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToSignup()
            })
            .disposed(by: disposeBag)
        
        self.input.townIntroButtonTrigger
            .subscribe(onNext: { cityCode in
                self.delegate.goToTownIntro(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
        
        self.output.favoriteDataSource.onNext(returnTownTestData())
        self.output.viewStatus.onNext(returnViewStatus())
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    
    func goToSignUp() {
        delegate.goToSignup()
    }
    
    func goToTownIntro(cityCode: Int) {
        delegate.goToTownIntro(cityCode: cityCode)
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
        return .isPresent
    }
    
    func returnTownTestData() -> [TownTableModel] {
        let test1 = TownTableModel(objectId: 321,
                                  county: "행운동",
                                  countyIcon: UIImage(named: "gwanak") ?? UIImage(),
                                  wishTown: false,
                                  safetyRate: 3,
                                  townIntroduction: "강남으로 출근하기 좋은 동네")
        let test2 = TownTableModel(objectId: 321,
                                  county: "행운동",
                                  countyIcon: UIImage(named: "gwanak") ?? UIImage(),
                                  wishTown: false,
                                  safetyRate: 3,
                                  townIntroduction: "강남으로 출근하기 좋은 동네")
        let test3 = TownTableModel(objectId: 321,
                                  county: "행운동",
                                  countyIcon: UIImage(named: "gwanak") ?? UIImage(),
                                  wishTown: false,
                                  safetyRate: 3,
                                  townIntroduction: "강남으로 출근하기 좋은 동네")
        let test4 = TownTableModel(objectId: 321,
                                  county: "행운동",
                                  countyIcon: UIImage(named: "gwanak") ?? UIImage(),
                                  wishTown: false,
                                  safetyRate: 3,
                                  townIntroduction: "강남으로 출근하기 좋은 동네")
       
        let towns = [test1, test2, test3, test4]
        return towns + towns
    }
}
