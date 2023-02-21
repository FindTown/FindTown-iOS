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
        let favoriteButtonTrigger = PublishSubject<Void>()
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
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var townIntroduceTask: Task<Void, Error>?
    private var favoriteTask: Task<Void, Error>?

    init(delegate: TownIntroduceViewModelDelegate,
         townUseCase: TownUseCase,
         authUseCase: AuthUseCase,
         memeberUseCase: MemberUseCase,
         cityCode: Int) {
        
        self.delegate = delegate
        self.townUseCase = townUseCase
        self.authUseCase = authUseCase
        self.memberUseCase = memeberUseCase
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
        
        self.input.favoriteButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.favorite()
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
    // 동네 소개
    func getTownIntroduceData() {
        self.townIntroduceTask = Task {
            do {
                var accessToken = ""
                if !UserDefaultsSetting.isAnonymous {
                    accessToken = try await self.authUseCase.getAccessToken()
                }
                
                let townIntroData = try await
                self.townUseCase.getTownIntroduce(cityCode: self.cityCode,
                                                  accessToken: accessToken)
               
                await MainActor.run(body: {
                    self.setTownIntroduceData(townIntroData: townIntroData)
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
    
    // 찜 등록, 해제
    func favorite() {
        self.favoriteTask = Task {
            do {
                let accessToken = try await self.authUseCase.getAccessToken()
                let favoriteStatus = try await self.memberUseCase.favorite(accessToken: accessToken,
                                                                           cityCode: cityCode)
                await MainActor.run(body: {
                    self.output.isFavorite.onNext(favoriteStatus)
                })
            } catch (let error) {
                await MainActor.run(body: {
                    self.output.errorNotice.onNext(())
                })
                Log.error(error)
            }
            
            favoriteTask?.cancel()
        }
    }
}

extension TownIntroduceViewModel {
    func setTownIntroduceData(townIntroData: TownIntroduce) {
        self.output.townTitle.onNext(townIntroData.townTitle)
        self.output.isFavorite.onNext(townIntroData.wishTown)
        self.output.townExplanation.onNext(townIntroData.townExplanation)
        self.output.townMoodDataSource.onNext(townIntroData.townMood)
        self.output.trafficDataSource.onNext(townIntroData.traffic)
        self.output.hotPlaceDataSource.onNext(townIntroData.hotPlace)
        self.output.townRankDataSource.onNext(townIntroData.townRank)
    }
}
