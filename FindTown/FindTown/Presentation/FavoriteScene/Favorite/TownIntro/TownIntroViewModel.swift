//
//  TownIntroViewModel.swift
//  FindTown
//
//  Created by 장선영 on 2023/01/29.
//

import Foundation
import FindTownCore
import RxSwift

final class TownIntroViewModel: BaseViewModel {
    
    struct Output {
        var townMoodDataSource = BehaviorSubject<[TownMood]>(value: [])
        var trafficDataSource = BehaviorSubject<[Traffic]>(value: [])
        var hotPlaceDataSource = BehaviorSubject<[String]>(value: [])
        var townRankDataSource = BehaviorSubject<[(String,Any)]>(value: [])
    }
    
    let output = Output()
    
    override init() {    
        super.init()
        self.bind()
    }
    
    func bind() {
        self.output.townMoodDataSource.onNext(returnTownMoodData())
        self.output.trafficDataSource.onNext(returnTrafficData())
        self.output.hotPlaceDataSource.onNext(returnHotPlaceData())
        self.output.townRankDataSource.onNext(returnTownRankData())
    }
}

// 임시 데이터
extension TownIntroViewModel {
    func returnTownMoodData() -> [TownMood] {
        let data =  ["배달시키기 좋은", "항상 사람이 많은", "교통정체가 심한", "번잡한","편의시설이 많은", "물가가 저렴한" ,"배달시키기 좋은", "번잡한"]
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
    
    func returnTownRankData() -> [(String,Any)] {
        let test = Essential()
        return test.toArray()
    }
}

struct Essential: Encodable {
    var test1 = "1"
    var test2 = "1"
    var test3 = "1"
    var test4 = "1"
    var test5 = ["30대 1인가구","2"]
    var test6 = "TOP 10"
    var test7 = "안심보안관 활동지"
    
    func toArray() -> [(String, Any)] {
        var array = [(String, Any)]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                switch child.value {
                case Optional<Any>.some(let value):
                    array.append((key, value))
                default:
                    continue
                }
            }
        }
        return array
    }
}
