//
//  TownRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation
import FindTownNetwork

final class DefaultTownRepository {
    
    func getTownInformation(filterStatus: String = "", subwayList: [String] = []) async throws -> TownFilterResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .contentType("application/json")])
        let townFilter = TownFilterDTO(filterStatus: filterStatus, subwayList: subwayList)
        let data = try await Network.shared.request(target: TownFilterRequest(task: .requestJSONEncodable(encodable: townFilter),
                                                                              HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func getSearchTownInformation(countyData: String) async throws -> TownSearchResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .contentType("application/json")])
        let townSearch = TownSearchDTO(sggNm: countyData)
        let data = try await Network.shared.request(target: TownSearchRequest(task: .requestJSONEncodable(encodable: townSearch),
                                                                              HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    /// 동네 소개 
    func getTownIntroduce(cityCode: Int, accessToken: String) async throws -> TownIntroduceResponseDTO {
        
        let httpHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        let parameters = [URLQueryItem(name: "objectId", value: String(cityCode))]
        
        let data = try await Network.shared.request(target: TownIntroduceRequest(HTTPHeaders: httpHeaders,
                                                                                 parameters: parameters))
        return data.body
    }
}
