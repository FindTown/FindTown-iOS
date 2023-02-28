//
//  TownUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation

final class TownUseCase {
    
    let townRepository: TownRepository
    
    init(townRepository: TownRepository
    ) {
        self.townRepository = townRepository
    }
    
    func getTownInformation(filterStatus: String = "", subwayList: [String] = [], accessToken: String = "") async throws -> TownFilterResponseDTO {
        return try await townRepository.getTownInformation(filterStatus: filterStatus,
                                                                  subwayList: subwayList,
                                                                  accessToken: accessToken)
    }
    
    func getSearchTownInformation(countyData: String, accessToken: String = "") async throws -> TownSearchResponseDTO {
        return try await townRepository.getSearchTownInformation(countyData: countyData,
                                                                        accessToken: accessToken)
    }
    
    func getTownIntroduce(cityCode: Int, accessToken: String) async throws -> TownIntroduce {
        return try await townRepository.getTownIntroduce(cityCode: cityCode,
                                                                accessToken: accessToken).townIntroduce.toEntity
    }
}
