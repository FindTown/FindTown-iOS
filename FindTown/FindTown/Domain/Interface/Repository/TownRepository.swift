//
//  TownRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol TownRepository {
    func getTownInformation(filterStatus: String, subwayList: [String], accessToken: String) async throws -> TownFilterResponseDTO
    func getSearchTownInformation(countyData: String, accessToken: String) async throws -> TownSearchResponseDTO
    func getTownIntroduce(cityCode: Int, accessToken: String) async throws -> TownIntroduceResponseDTO
}
