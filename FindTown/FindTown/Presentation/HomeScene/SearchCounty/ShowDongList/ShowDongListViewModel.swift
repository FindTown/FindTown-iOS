//
//  GuSelectDongViewModel.swift
//  FindTown
//
//  Created by 김성훈 on 2023/01/24.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

final class ShowDongListViewModel: BaseViewModel {

    struct Input {
        
    }
    
    struct Output {
        var searchTownTableDataSource = BehaviorRelay<[townModelTest]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    
    override init() {
        super.init()
        self.bind()
    }

    func bind() {

        // 임시
        self.output.searchTownTableDataSource.accept(returnTownTestData())
    }
}

extension ShowDongListViewModel {
    func returnTownTestData() -> [townModelTest] {
        let demoTown1 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown2 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown3 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown4 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown5 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown6 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        let demoTown7 = townModelTest(image: "map", dong: "신림동", introduce: "자취생들이 많이 사는 동네")
        
        let towns = [demoTown1, demoTown2, demoTown3, demoTown4, demoTown5, demoTown6, demoTown7]
        return towns
    }
}
