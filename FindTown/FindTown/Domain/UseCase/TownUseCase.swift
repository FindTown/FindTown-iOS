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
    
    func getSearchTownInformation() {
        
    }
    
//    func getTownIntro(cityCode: Int?, accessToken: String?) async throws -> TownIntroResponseDTO {
//        return try await defaultTownRepository.getTownIntro(cityCode: cityCode,
//                                                            accessToken: accessToken)
//    }
}
