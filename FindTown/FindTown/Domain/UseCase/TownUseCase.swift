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
    
    func getTownInfomation(accessToken: String = "",
                           filterStatus: String = "",
                           subwayList: [String] = []
    ) async throws -> TownFilterResponseDTO {
        return try await defaultTownRepository.getTownInfomation(accessToken: accessToken,
                                                                 filterStatus: filterStatus,
                                                                 subwayList: subwayList)
    }
    
    func getSearchTownInfomation() {
        
    }
}
