//
//  TownRepository.swift
//  FindTown
//
//  Created by 김성훈 on 2023/02/12.
//

import Foundation
import FindTownNetwork

final class DefaultTownRepository: TownRepository {
    
    func getTownInformation(filterStatus: String = "", subwayList: [String] = [], accessToken: String = "") async throws -> TownFilterResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .contentType("application/json"),
                                       .authorization(bearerToken: accessToken)])
        let townFilter = TownFilterDTO(filterStatus: filterStatus, subwayList: subwayList)
        let data = try await Network.shared.request(target: TownFilterRequest(task: .requestJSONEncodable(encodable: townFilter),
                                                                              HTTPHeaders: HTTPHeaders))
        return data.body
    }
    
    func getSearchTownInformation(searchType: SearchType, data: String, accessToken: String) async throws -> TownSearchResponseDTO {
        let HTTPHeaders = HTTPHeaders([.accept("*/*"),
                                       .contentType("application/json"),
                                       .authorization(bearerToken: accessToken)])
        let path = "/app/town/search/\(searchType.rawValue)"
        let parameters = [URLQueryItem(name: "keyword", value: data)]
        
        let data = try await Network.shared.request(
            target: TownSearchRequest(path: path,
                                      parameters: parameters,
                                      headers: HTTPHeaders),
            cachePolicy: .returnCacheDataElseLoad)
        
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
