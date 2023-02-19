//
//  TownIntroViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import Foundation
import FindTownCore
import RxSwift
         

protocol TownIntroduceViewModelType {
    func goToMap()
}

protocol TownIntroduceViewModelDelegate {
    func goToMap()
}

final class TownIntroduceViewModel: BaseViewModel {
    
    struct Input {
        let moveToMapButtonTrigger = PublishSubject<Void>()
        let favoriteButtonTrigger = PublishSubject<Bool>()
    }
        
    struct Output {
        var isFavorite = BehaviorSubject<Bool>(value: false)
        var townTitle = BehaviorSubject<String>(value: "")
        var townExplanation = BehaviorSubject<String>(value: "")
        var townMoodDataSource = BehaviorSubject<[TownMood]>(value: [])
        var trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        var hotPlaceDataSource = BehaviorSubject<[String]>(value: [])
        var townRankDataSource = BehaviorSubject<[(TownRank,Any)]>(value: [])
        let errorNotice = PublishSubject<Void>()
    }
    
    let delegate: TownIntroduceViewModelDelegate
    let input = Input()
    let output = Output()
    let cityCode: Int
    
    // MARK: - UseCase
    
    let townUseCase: TownUseCase
    let authUseCase: AuthUseCase
    
    // MARK: - Task
    
    private var townIntroduceTask: Task<Void, Error>?

    init(delegate: TownIntroduceViewModelDelegate,
         townUseCase: TownUseCase,
         authUseCase: AuthUseCase,
         cityCode: Int) {
        
        self.delegate = delegate
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.cityCode = cityCode
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.moveToMapButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToMap()
            })
            .disposed(by: disposeBag)
    }
}

extension TownIntroduceViewModel: TownIntroduceViewModelType {
    func goToMap() {
        self.delegate.goToMap()
    }
}

extension TownIntroduceViewModel {
    func getTownIntroduceData() {
        self.townIntroduceTask = Task {
            do {
                var accessToken = ""
                //TODO: isAnonymous 적용
                if true {
                    accessToken = try await self.authUseCase.getAccessToken()
                }
                
                let townIntroData = try await
                self.townUseCase.getTownIntroduce(cityCode: self.cityCode,
                                                  accessToken: accessToken)

                await MainActor.run(body: {
                    self.setTownIntroduceData(townIntroData: townIntroData.townIntroduce)
                })
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                }
                Log.error(error)
            }
            townIntroduceTask?.cancel()
        }
        
    }
    
    func setTownIntroduceData(townIntroData: TownIntroduceDTO) {
        
        self.output.townTitle.onNext(townIntroData.convertTownTitle)
        self.output.isFavorite.onNext(townIntroData.wishTown)
        self.output.townExplanation.onNext(townIntroData.townExplanation)
        self.output.townMoodDataSource.onNext(townIntroData.convertTownMood)
        self.output.trafficDataSource.onNext(townIntroData.convertTraffic)
        
        // TODO: hotplaceList db 추가 후 수정 예정
        let hotPlaceList = townIntroData.townHotPlaceList.filter{ $0 != nil }.map { $0! }
        self.output.hotPlaceDataSource.onNext(hotPlaceList)
        self.output.townRankDataSource.onNext(townIntroData.convertTownRank())
    }
}

