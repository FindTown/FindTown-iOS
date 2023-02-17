//
//  TownIntroViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import Foundation
import FindTownCore
import RxSwift
         

protocol TownIntroViewModelType {
    func goToMap()
}

protocol TownIntroViewModelDelegate {
    func goToMap()
}

final class TownIntroViewModel: BaseViewModel {
    
    struct Input {
        let moveToMapButtonTrigger = PublishSubject<Void>()
    }
        
    struct Output {
        var townMoodDataSource = BehaviorSubject<[TownMood]>(value: [])
        var trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        var hotPlaceDataSource = BehaviorSubject<[String]>(value: [])
        var townRankDataSource = BehaviorSubject<[(TownRank,Any)]>(value: [])
    }
    
    let delegate: TownIntroViewModelDelegate
    let input = Input()
    let output = Output()
    
    // MARK: - Task
    
    private var townIntroDataTask: Task<Void, Error>?

    init(delegate: TownIntroViewModelDelegate) {
        self.delegate = delegate
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.moveToMapButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.delegate.goToMap()
            })
            .disposed(by: disposeBag)
      
        self.output.townMoodDataSource.onNext(returnTownMoodData())
        self.output.trafficDataSource.onNext(returnTrafficData())
        self.output.hotPlaceDataSource.onNext(returnHotPlaceData())
        self.output.townRankDataSource.onNext(returnTownRankData())
    }
}

extension TownIntroViewModel: TownIntroViewModelType {
    func goToMap() {
        self.delegate.goToMap()
    }
}

// MARK: Network

extension TownIntroViewModel {
    func getTownIntroData(cityCode: Int?) {
        self.townIntroDataTask = Task {
            do {
                
            } catch(let error) {
                
            }
        }
    }
}



// 임시 데이터
extension TownIntroViewModel {
    func returnTownMoodData() -> [TownMood] {
        let data =  ["배달시키기 좋은", "항상 사람이 많은"]
        var townMoodArray: [TownMood] = []
        
        for mood in data {
            if let mood = TownMood.returnTrafficType(mood) {
                townMoodArray.append(mood)
            }
        }
        return townMoodArray
    }
    
    func returnTrafficData() -> [Traffic] {
        let data = ["1", "2", "3"]
        var trafficArray: [Traffic] = []
      
        for traffic in data {
            if let traffic =  Traffic.returnTrafficType(traffic) {
                trafficArray.append(traffic)
            }
        }
        return trafficArray
    }
    
    func returnHotPlaceData() -> [String] {
        return ["타임 스트림", "신림 순대타운"]
    }
    
    func returnTownRankData() -> [(TownRank,Any)] {
        let test = TownRankData()
        return test.toArray()
    }
}

struct TownRankData: Encodable {
    var lifeSafety = "1"
    var crime = "1"
    var traffic = "1"
    var livable = "1"
    var popular = ["30대 1인가구","2"]
    var clean = "TOP 10"
    var safety = "안심보안관 활동지"
    
    func toArray() -> [(TownRank, Any)] {
        var array = [(TownRank, Any)]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label,
               let typeKey = TownRank.returnTownRankType(key) {
                switch child.value {
                case Optional<Any>.some(let value):
                    array.append((typeKey, value))
                default:
                    continue
                }
            }
        }
        return array
    }
}
