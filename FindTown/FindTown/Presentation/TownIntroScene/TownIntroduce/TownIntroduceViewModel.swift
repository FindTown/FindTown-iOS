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
    var cityCode: Int
    
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
    func getTownIntroData() {
        self.townIntroduceTask = Task {
            do {
                var accessToken = ""
                //TODO: isAnonymous 적용
                if true {
                    accessToken = try await self.authUseCase.getAccessToken()
                }
                
                let townIntroData = try await self.townUseCase.getTownIntroduce(cityCode: self.cityCode,
                                                                            accessToken: accessToken)

                await MainActor.run(body: {
                    self.setTownIntroData(data: townIntroData.townIntroduce)
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
    
    func setTownIntroData(data: TownIntroduceDTO) {
        
        if let city = CityCode.init(rawValue: cityCode) {
            let townTitle = City(county: city.county, village: city.village).description
            self.output.townTitle.onNext(townTitle)
        }
        
        self.output.isFavorite.onNext(data.wishTown)
        self.output.townExplanation.onNext(data.townExplanation)
        self.output.townMoodDataSource.onNext(convertTownMoodData(data.townMoodList))
        self.output.trafficDataSource.onNext(convertTrafficData(data.townSubwayList))
        let hotPlaceList = data.townHotPlaceList.filter{ $0 != nil }.map { $0! }
        self.output.hotPlaceDataSource.onNext(hotPlaceList)
        self.output.townRankDataSource.onNext(self.convertTownRankData(data: data))
    }
}

extension TownIntroduceViewModel {
    func convertTownMoodData(_ townMoodStringArray: [String]) -> [TownMood] {
        var townMoodArray: [TownMood] = []
        
        for mood in townMoodStringArray {
            if let mood = TownMood.returnTrafficType(mood) {
                townMoodArray.append(mood)
            }
        }
        return townMoodArray
    }
    
    func convertTrafficData(_ trafficStringArray: [String]) -> [Traffic] {
        var trafficArray: [Traffic] = []
      
        for traffic in trafficStringArray {
            if let traffic =  Traffic.returnTrafficType(traffic) {
                trafficArray.append(traffic)
            }
        }
        
        return trafficArray
    }
    
    func convertTownRankData(data: TownIntroduceDTO) -> [(TownRank,Any)] {
        let popular = data.popularGeneration == 0 ? nil : ["\(data.popularGeneration)대 1인가구",
                                                           "\(data.popularTownRate)"]
        let townRankData = TownRankData(lifeRank: data.lifeRate,
                                        crimeRank: data.crimeRate,
                                        trafficRank: data.trafficRate,
                                        liveRank: data.liveRank == 0 ? nil : data.liveRank,
                                        popular: popular,
                                        cleanRank: data.cleanlinessRank == "N" ? nil : data.cleanlinessRank,
                                        safety: data.reliefYn == "Y" ? "안심보안관 활동지" : nil)
        
        return townRankData.toArray()
    }
}
