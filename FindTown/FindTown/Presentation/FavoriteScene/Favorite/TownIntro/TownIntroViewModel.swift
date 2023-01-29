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
}
