//
//  MapViewMode.swift
//  FindTown
//
//  Created by 이호영 on 2022/12/25.
//

import Foundation
import UIKit
import FindTownCore
import FindTownNetwork

import RxSwift
import RxCocoa

protocol MapViewModelDelegate {
    func gotoIntroduce()
    func presentAddressSheet()
    func setCityData(_ city: City)
}

protocol MapViewModelType {
    func gotoIntroduce()
    func presentAddressSheet()
}

final class MapViewModel: BaseViewModel {
    let delegate: MapViewModelDelegate
    
    struct Input {
        let segmentIndex = BehaviorRelay<Int>(value: 0)
        let didTapFavoriteButton = PublishSubject<Bool>()
    }
    
    struct Output {
        var categoryDataSource = BehaviorSubject<[MCategory]>(value: [])
        var storeDataSource = BehaviorSubject<[Store]>(value: [])
        var city = PublishSubject<City>()
        var cityBoundaryCoordinates = PublishSubject<[[Double]]>()
        var isFavoriteCity = PublishSubject<Bool>()
    }
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let mapUseCase: MapUseCase
    
    // MARK: - Task
    
    private var cityDataTask: Task<Void, Error>?
    
    let input = Input()
    let output = Output()
    
    init(delegate: MapViewModelDelegate,
         authUseCase: AuthUseCase,
         mapUseCase: MapUseCase) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.mapUseCase = mapUseCase
        
        super.init()
        self.bind()
    }
    
    func bind() {
        self.input.segmentIndex
            .bind { [weak self] index in
                if index == 0 {
                    self?.output.categoryDataSource.onNext(InfraCategory.allCases)
                } else {
                    self?.output.categoryDataSource.onNext(ThemaCategory.allCases)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(self.input.didTapFavoriteButton, self.output.city)
            .subscribe { [weak self] isFavorite, city in
                if isFavorite {
                    self?.addFavoriteCity(city)
                } else {
                    self?.removeFavoriteCity(city)
                }
            }
            .disposed(by: disposeBag)
        
        self.output.storeDataSource.onNext(returnStoreTestData())
    }
}

// MARK: - Network

extension MapViewModel {
    func setCity(city: City? = nil) {
        
        self.cityDataTask = Task {
            do {
                var cityCode: Int? = nil
                if let city = city {
                    cityCode = CityCode(county: city.county, village: city.village)?.rawValue
                }
                let accessToken = try await self.authUseCase.getAccessToken()
                let villageLocaionInformation = try await self.mapUseCase.getVillageCoordinate(cityCode: cityCode, accessToken: accessToken)
                guard let cityCode = CityCode(rawValue: villageLocaionInformation.cityCode) else {
                    cityDataTask?.cancel()
                    return
                }
                await MainActor.run {
                    let city = City(county: cityCode.county, village: cityCode.village)
                    self.output.city.onNext(city)
                    self.output.cityBoundaryCoordinates.onNext(villageLocaionInformation.coordinate)
                }
                cityDataTask?.cancel()
            } catch (let error) {
                if let error = error as? FTNetworkError,
                   FTNetworkError.isUnauthorized(error: error) {
                    let villageLocaionInformation = try await self.mapUseCase.getVillageCoordinate(cityCode: nil, accessToken: nil)
                    guard let cityCode = CityCode(rawValue: villageLocaionInformation.cityCode) else {
                        cityDataTask?.cancel()
                        return
                    }
                    await MainActor.run {
                        let city = City(county: cityCode.county, village: cityCode.village)
                        self.output.city.onNext(city)
                        self.output.cityBoundaryCoordinates.onNext(villageLocaionInformation.coordinate)
                    }
                } else {
//                    await MainActor.run {
//                        self.output.errorNotice.onNext(())
//                    }
                    Log.error(error)
                }
            }
        }
    }
    
    func addFavoriteCity(_ city: City) {
        
    }
    
    func removeFavoriteCity(_ city: City) {
        
    }
}


extension MapViewModel: MapViewModelType {
    
    func gotoIntroduce() {
        delegate.gotoIntroduce()
    }
    
    func presentAddressSheet() {
        delegate.presentAddressSheet()
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
        let stores = [Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .chineseFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .koreanFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .westernFood)),
                          Store(name: "프레퍼스 다이어트 푸드", address: "서울 강서구 마곡중앙5로 6 마곡나루역", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .worldFood)),
                          Store(name: "미정국수0410 멸치국수 잘하는집 신촌점", address: "서울 강서구 마곡중앙5로 6 마곡나루역 보타닉푸르지오시티 1층 114호", thema:
                                    Thema(storeType: .restaurent, storeDetailType: .fastFood)),
                          ]
        return stores
    }
}
