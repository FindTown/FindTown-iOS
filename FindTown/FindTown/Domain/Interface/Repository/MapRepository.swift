//
//  MapRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/28.
//

import Foundation

protocol MapRepository {
    func getVillageLocationData(cityCode: Int?, _ accessToken: String?) async throws -> TownMapLocationDTO
    func getInfraStores(cityCode: String, categoryId: String) async throws -> MapThemaStoreResponseDTO
    func getThemaStores(cityCode: String, categoryId: String) async throws -> MapThemaStoreResponseDTO
}
