//
//  TownRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation
import FindTownNetwork

final class DefaultTownRepository {
    
    func getTownInfomation(accessToken: String,
                           filterStatus: String = "",
                           subwayList: [String] = []
    ) async throws -> TownFilterResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken),
                                       .contentType("application/json")])
        let townFilter = TownFilterDTO(filterStatus: filterStatus, subwayList: subwayList)
        let data = try await Network.shared.request(target: TownFilterRequest(task: .requestJSONEncodable(encodable: townFilter),
                                                                              HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func getSearchTownInfomation() {
        
    }
}
