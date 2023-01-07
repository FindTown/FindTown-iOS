//
//  MapViewMode.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation
import UIKit
import FindTownCore

import RxSwift
import RxCocoa

protocol MapViewModelDelegate {
    func gotoIntroduce()
    func presentAddressPopup()
}

protocol MapViewModelType {
    func gotoIntroduce()
    func presentAddressPopup()
}

final class MapViewModel: BaseViewModel {
    let delegate: MapViewModelDelegate
    
    struct Input {
        let segmentIndex = BehaviorRelay<Int>(value: 0)
    }
    
    struct Output {
        var categoryDataSource = BehaviorSubject<[Category]>(value: [])
        var storeDataSource = BehaviorSubject<[Store]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    
    init(delegate: MapViewModelDelegate) {
        self.delegate = delegate
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        self.input.segmentIndex
            .bind { [weak self] index in
                if index == 0 {
                    self?.output.categoryDataSource.onNext(self?.returnInfraTestData() ?? [])
                } else {
                    self?.output.categoryDataSource.onNext(self?.returnThemaTestData() ?? [])
                }
            }
            .disposed(by: disposeBag)
        
        self.output.storeDataSource.onNext(returnStoreTestData())
    }
}

extension MapViewModel: MapViewModelType {
    
    func gotoIntroduce() {
        delegate.gotoIntroduce()
    }
    
    func presentAddressPopup() {
        delegate.presentAddressPopup()
    }
}

extension MapViewModel {
    func returnInfraTestData() -> [Category] {
        let detailCategories1 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점편의점편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
        let detailCategories2 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
    
        let categories = [Category(image: UIImage(named: "martIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "마트&편의점",
                                   detailCategories: detailCategories1),
                          Category(image: UIImage(named: "cafeIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "카페",
                                   detailCategories: detailCategories2),
                          Category(image: UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "치안",
                                   detailCategories: detailCategories1)]
        return categories
    }
    
    func returnThemaTestData() -> [Category] {
        let detailCategories1 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점편의점편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
        let detailCategories2 = [DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 210,
                                                                   blue: 49),
                                               detailTitle: "편의점"),
                                DetailCategory(color: UIColor.init(red: 255,
                                                                   green: 30,
                                                                   blue: 30),
                                               detailTitle: "편의점")]
        
    
        let categories = [Category(image: UIImage(named: "martIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "혼밥하기 좋은 식당",
                                   detailCategories: detailCategories1),
                          Category(image: UIImage(named: "cafeIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "공부하기 좋은 카페",
                                   detailCategories: detailCategories1),
                          Category(image: UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
                                   title: "반려견 동물과 동반 가능한 ",
                                   detailCategories: detailCategories1)]
        return categories
    }
    
    func returnStoreTestData() -> [Store] {
        let stores = [Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, detailStoreType: .fastFood)),
                          ]
        return stores
    }
}
