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
    func goToLogin()
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
}

protocol FavoriteViewModelDelegate {
    func goToLogin()
    func goToTownIntroduce(cityCode: Int)
    func goToTownMap(cityCode: Int)
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
        let townMapButtonTrigger = PublishSubject<Int>()
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
                self?.delegate.goToLogin()
            })
            .disposed(by: disposeBag)
        
        self.input.townIntroButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.delegate.goToTownIntroduce(cityCode: cityCode)
            })
            .disposed(by: disposeBag)
        
        self.input.townMapButtonTrigger
            .subscribe(onNext: { [weak self] cityCode in
                self?.delegate.goToTownMap(cityCode: cityCode)
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
    
    func goToTownIntroduce(cityCode: Int) {
        delegate.goToTownIntroduce(cityCode: cityCode)
    }
    
    func goToTownMap(cityCode: Int) {
        delegate.goToTownMap(cityCode: cityCode)
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
