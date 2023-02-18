//
//  TownUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation

final class TownUseCase {
    
    let defaultTownRepository: DefaultTownRepository
    
    init() {
        self.defaultTownRepository = DefaultTownRepository()
    }
    
    func getTownInformation(filterStatus: String = "", subwayList: [String] = []) async throws -> TownFilterResponseDTO {
        return try await defaultTownRepository.getTownInformation(filterStatus: filterStatus,
                                                                  subwayList: subwayList)
    }
    
    func getSearchTownInformation(countyData: String) async throws -> TownSearchResponseDTO {
        return try await defaultTownRepository.getSearchTownInformation(countyData: countyData)
    }
}
