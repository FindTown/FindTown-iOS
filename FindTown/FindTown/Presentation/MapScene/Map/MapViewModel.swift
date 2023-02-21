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
        let themaStoreDataSource = PublishSubject<[ThemaStore]>()
        let infraStoreDataSource = PublishSubject<[InfraStore]>()
        let city = PublishSubject<City>()
        let cityBoundaryCoordinates = PublishSubject<[[Double]]>()
        let isFavoriteCity = PublishSubject<Bool>()
        let changeFavoriteStauts = PublishSubject<Bool>()
        let errorNotice = PublishSubject<Void>()
    }
    
    // MARK: - Proerty
    var cityCode: Int?
    
    // MARK: - UseCase
    
    let authUseCase: AuthUseCase
    let mapUseCase: MapUseCase
    let memberUseCase: MemberUseCase
    
    // MARK: - Task
    
    private var cityDataTask: Task<Void, Error>?
    private var themaStoreDataTask: Task<Void, Error>?
    private var favoriteTask: Task<Void, Error>?
    
    let input = Input()
    let output = Output()
    
    init(delegate: MapViewModelDelegate,
         authUseCase: AuthUseCase,
         mapUseCase: MapUseCase,
         memberUseCase: MemberUseCase,
         cityCode: Int?) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.mapUseCase = mapUseCase
        self.memberUseCase = memberUseCase
        self.cityCode = cityCode
        
        super.init()
    }
}

// MARK: - Network

extension MapViewModel {
    func setCity(cityCode: Int? = nil, informationPresentType: InformationPresentType) {
        
        self.cityDataTask = Task {
            do {
                var villageLocaionInformation: VillageLocationInformation
                if UserDefaultsSetting.isAnonymous == false {
                    let accessToken = try await self.authUseCase.getAccessToken()
                    if let cityCode = cityCode {
                        villageLocaionInformation = try await self.mapUseCase.getVillageLocationInformation(cityCode: cityCode, accessToken: accessToken)
                    } else {
                        villageLocaionInformation = try await self.mapUseCase.getVillageLocationInformation(cityCode: nil, accessToken: accessToken)
                    }
                } else {
                    villageLocaionInformation = try await self.mapUseCase.getVillageLocationInformation(cityCode: nil, accessToken: nil)
                }
                let coordinate = villageLocaionInformation.coordinate
                let isFavorite = villageLocaionInformation.wishStatus
                guard let cityCode = CityCode(rawValue: villageLocaionInformation.cityCode) else {
                    cityDataTask?.cancel()
                    return
                }
                await MainActor.run {
                    let city = City(county: cityCode.county, village: cityCode.village)
                    self.output.city.onNext(city)
                    self.output.cityBoundaryCoordinates.onNext(coordinate)
                    
                    switch informationPresentType {
                    case .setting:
                        self.output.isFavoriteCity.onNext(isFavorite)
                    case .tap:
                        self.output.changeFavoriteStauts.onNext(isFavorite)
                    }
                    
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
    
    func getThemaData(category: ThemaCategory) {
        self.themaStoreDataTask = Task {
            do {
                guard let cityCode = self.cityCode else {
                    return
                }
                let themaStores = try await self.mapUseCase.getThemaStores(cityCode: cityCode, categoryId: category.code)

                await MainActor.run {
                    self.output.themaStoreDataSource.onNext(themaStores)
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
        self.themaStoreDataTask = Task {
            do {
                guard let cityCode = self.cityCode else {
                    return
                }
                let infraStores = try await self.mapUseCase.getInfraStores(cityCode: cityCode, categoryId: category.code)

                await MainActor.run {
                    self.output.infraStoreDataSource.onNext(infraStores)
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
    
    func changeFavoriteStauts(informationPresentType: InformationPresentType) {
        self.favoriteTask = Task {
            do {
                guard let cityCode = self.cityCode else {
                    return
                }
                
                let accessToken = try await self.authUseCase.getAccessToken()
                let favoriteStatus = try await self.memberUseCase.favorite(accessToken: accessToken,
                                                                           cityCode: cityCode)
                await MainActor.run(body: {
                    self.output.isFavoriteCity.onNext(favoriteStatus)
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
