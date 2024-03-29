//
//  MapUseCase.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation

protocol MapUseCase {
    func getVillageLocationInformation(cityCode: Int?, accessToken: String?) async throws -> VillageLocationInformation
    func getThemaStores(cityCode: Int, categoryId: String) async throws -> [ThemaStore]
    func getInfraStores(cityCode: Int, categoryId: String) async throws -> [InfraStore]
}

final class DefaultMapUseCase: MapUseCase {
    
    let mapRepository: MapRepository
    
    init(mapRepository: MapRepository
    ) {
        self.mapRepository = mapRepository
    }
    
    func getVillageLocationInformation(cityCode: Int?, accessToken: String?) async throws -> VillageLocationInformation {
        return try await mapRepository.getVillageLocationData(cityCode: cityCode, accessToken).locationInfo.toEntity()
    }
    
    func getThemaStores(cityCode: Int, categoryId: String) async throws -> [ThemaStore] {
        return try await mapRepository.getThemaStores(cityCode: String(cityCode), categoryId: categoryId).placeList.map { $0.toThemaStoreEntity() }
    }
    
    func getInfraStores(cityCode: Int, categoryId: String) async throws -> [InfraStore] {
        return try await mapRepository.getInfraStores(cityCode: String(cityCode), categoryId: categoryId).placeList.map { $0.toInfraStoreEntity() }
    }
}
