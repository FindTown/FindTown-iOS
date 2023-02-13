//
//  MapUseCase.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation

final class MapUseCase {
    
    let mapRepository: DefaultMapRepository
    let tokenRepository: DefaultTokenRepository
    
    init() {
        self.mapRepository = DefaultMapRepository()
        self.tokenRepository = DefaultTokenRepository()
    }
    
    func getFirstVillageCoordinate(cityCode: Int?) async throws -> [[Double]] {
        return try await mapRepository.getVillageCoordinate(cityCode: cityCode).locationInfo.coordinates
    }
    
    func getVillageCoordinate(cityCode: Int?, accessToken: String?) async throws -> VillageLocationInformation {
        return try await mapRepository.getVillageCoordinate(cityCode: cityCode, accessToken).locationInfo.toEntity()
    }
}
