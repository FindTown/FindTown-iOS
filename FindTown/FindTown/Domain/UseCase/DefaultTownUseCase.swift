//
//  TownUseCase.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation

protocol TownUseCase {
    func getTownInformation(filterStatus: String, subwayList: [String], accessToken: String) async throws -> TownFilterResponseDTO

    func getSearchTownInformation(
        searchType: SearchType,
        data: String,
        accessToken: String) async throws -> TownSearchResponseDTO
    
    func getTownIntroduce(cityCode: Int, accessToken: String) async throws -> TownIntroduce
}

final class DefaultTownUseCase: TownUseCase {
    
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
    
    func getSearchTownInformation(searchType: SearchType, data: String, accessToken: String = "") async throws -> TownSearchResponseDTO {
        return try await townRepository.getSearchTownInformation(
            searchType: searchType,
            data: data,
            accessToken: accessToken)
    }
    
    func getTownIntroduce(cityCode: Int, accessToken: String) async throws -> TownIntroduce {
        return try await townRepository.getTownIntroduce(cityCode: cityCode,
                                                                accessToken: accessToken).townIntroduce.toEntity
    }
}
