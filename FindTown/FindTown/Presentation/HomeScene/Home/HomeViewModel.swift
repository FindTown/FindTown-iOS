//
//  HomeViewModel.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation

import FindTownCore
import RxSwift
import RxRelay

protocol HomeViewModelDelegate {
    func goToFilterBottomSheet()
    func goToGuSearchView()
}

protocol HomeViewModelType {
    func goToFilterBottomSheet()
    func goToGuSearchView()
}

// 임시
struct townModelTest {
    let image: String
    let dong: String
    let introduce: String
}

final class HomeViewModel: BaseViewModel {

    struct Input {
        let resetButtonTrigger = PublishSubject<Void>()
        let filterButtonTrigger = PublishSubject<Void>()
        let searchButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        var searchFilterDataSource = BehaviorRelay<[String]>(value: [])
        var searchTownTableDataSource = BehaviorRelay<[townModelTest]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let delegate: HomeViewModelDelegate
    
    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.searchButtonTrigger
            .bind(onNext: goToGuSearchView)
            .disposed(by: disposeBag)
        
        self.input.resetButtonTrigger
            .withLatestFrom(input.resetButtonTrigger)
            .bind { [weak self] in
                
                // 초기화 세팅
                let searchCategoryModel = ["인프라", "교통"]
                self?.output.searchFilterDataSource.accept(searchCategoryModel)
            }
            .disposed(by: disposeBag)
        
        self.input.filterButtonTrigger
            .withLatestFrom(input.filterButtonTrigger)
            .bind(onNext: goToFilterBottomSheet)
            .disposed(by: disposeBag)
        
        // 임시
        let searchCategoryModel = ["인프라", "교통"]
        self.output.searchFilterDataSource.accept(searchCategoryModel)
        self.output.searchTownTableDataSource.accept(returnTownTestData())
    }
}

extension HomeViewModel: HomeViewModelType {
    
    func goToFilterBottomSheet() {
        delegate.goToFilterBottomSheet()
    }
    
    func goToGuSearchView() {
        delegate.goToGuSearchView()
    }
}

extension HomeViewModel {
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
