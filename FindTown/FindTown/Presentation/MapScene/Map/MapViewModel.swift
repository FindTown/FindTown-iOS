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
    func gotoIntroduce(cityCode: Int)
    func presentAddressSheet()
    func setCityData(_ city: Int)
    func presentInformationUpdateScene()
}

protocol MapViewModelType {
    func gotoIntroduce(cityCode: Int)
    func presentAddressSheet()
    func presentInformationUpdateScene()
}

final class MapViewModel: BaseViewModel {
    let delegate: MapViewModelDelegate
    
    struct Input {
        let segmentIndex = BehaviorRelay<Int>(value: 0)
        let didTapFavoriteButton = PublishSubject<Bool>()
    }
    
    struct Output {
        let categoryDataSource = BehaviorSubject<[Category]>(value: [])
        let storeDataSource = PublishSubject<[ThemaStore]>()
        let city = PublishSubject<City>()
        let cityBoundaryCoordinates = PublishSubject<[[Double]]>()
        let isFavoriteCity = PublishSubject<Bool>()
        let errorNotice = PublishSubject<Void>()
    }
    
    // MARK: - Proerty
    var cityCode: Int?
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let mapUseCase: MapUseCase
    
    // MARK: - Task
    
    private var cityDataTask: Task<Void, Error>?
    private var themaStoreDataTask: Task<Void, Error>?
    
    let input = Input()
    let output = Output()
    
    init(delegate: MapViewModelDelegate,
         authUseCase: AuthUseCase,
         mapUseCase: MapUseCase,
         cityCode: Int?) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.mapUseCase = mapUseCase
        self.cityCode = cityCode
        
        super.init()
        self.bind()
    }
    
    func bind() {
        
        Observable.combineLatest(self.input.didTapFavoriteButton, self.output.city)
            .subscribe { [weak self] isFavorite, city in
                if isFavorite {
                    self?.addFavoriteCity(city)
                } else {
                    self?.removeFavoriteCity(city)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Network

extension MapViewModel {
    func setCity(cityCode: Int? = nil) {
        
        self.cityDataTask = Task {
            do {
                var villageLocaionInformation: VillageLocationInformation
                if UserDefaultsSetting.isAnonymous == false,
                   let cityCode = cityCode {
                    let accessToken = try await self.authUseCase.getAccessToken()
                    villageLocaionInformation = try await self.mapUseCase.getVillageLocationInformation(cityCode: cityCode, accessToken: accessToken)
                } else {
                    villageLocaionInformation = try await self.mapUseCase.getVillageLocationInformation(cityCode: nil, accessToken: nil)
                }
                let coordinate = villageLocaionInformation.coordinate
                guard let cityCode = CityCode(rawValue: villageLocaionInformation.cityCode) else {
                    cityDataTask?.cancel()
                    return
                }
                await MainActor.run {
                    let city = City(county: cityCode.county, village: cityCode.village)
                    self.output.city.onNext(city)
                    self.output.cityBoundaryCoordinates.onNext(coordinate)
                }
                cityDataTask?.cancel()
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                }
                Log.error(error)
            }
        }
    }
    
    func getThemaData(category: ThemaCategory, city: City) {
        self.themaStoreDataTask = Task {
            do {
                guard let cityCode = CityCode(county: city.county, village: city.village)?.rawValue else {
                    return
                }
                let themaStores = try await self.mapUseCase.getThemaStores(cityCode: cityCode, categoryId: category.code)

                await MainActor.run {
                    self.output.storeDataSource.onNext(themaStores)
                }
                themaStoreDataTask?.cancel()
            } catch (let error) {
                await MainActor.run {
                    self.output.errorNotice.onNext(())
                }
                Log.error(error)
                themaStoreDataTask?.cancel()
            }
        }
    }
    
    func getInfraData(category: InfraCategory) {
        
    }
    
    func addFavoriteCity(_ city: City) {
        
    }
    
    func removeFavoriteCity(_ city: City) {
        
    }
}

extension MapViewModel: MapViewModelType {
    func presentInformationUpdateScene() {
        delegate.presentInformationUpdateScene()
    }
    
    func gotoIntroduce(cityCode: Int) {
        delegate.gotoIntroduce(cityCode: cityCode)
    }
    
    func presentAddressSheet() {
        delegate.presentAddressSheet()
    }
}
