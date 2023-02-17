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
    
    func getSearchTownInformation() {
        
    }
    
    /// 동네 소개 
//    func getTownIntro(cityCode: Int?, accessToken: String?) async throws -> TownIntroResponseDTO {
//        var httpHeaders = HTTPHeaders([.accept("*/*")])
//        var parameters: [URLQueryItem]? = nil
//        
//        if let accessToken = accessToken {
//            httpHeaders = HTTPHeaders([.accept("*/*"),
//                                       .authorization(bearerToken: accessToken)])
//        }
//        
//        if let cityCode = cityCode {
//            parameters = [URLQueryItem(name: "objectId", value: String(cityCode))]
//        }
//        
//        let data = try await Network.shared.request(target: TownIntroRequest(HTTPHeaders: httpHeaders, parameters: parameters))
//        
//        print(data.body)
//        
//        return data.body
//    }
}
