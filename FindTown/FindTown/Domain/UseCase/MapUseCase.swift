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
    
    func getVillageLocationInformation(cityCode: Int?, accessToken: String?) async throws -> VillageLocationInformation {
        return try await mapRepository.getVillageLocationData(cityCode: cityCode, accessToken).locationInfo.toEntity()
    }
}
