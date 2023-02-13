//
//  DefaultMapRepository.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/13.
//

import Foundation
import FindTownNetwork

final class DefaultMapRepository {

    func getVillageCoordinate(cityCode: Int?, _ accessToken: String? = nil) async throws -> TownMapLocationDTO {
        var httpHeaders: HTTPHeaders = HTTPHeaders([.accept("*/*")])
        var parameters: [URLQueryItem]? = nil
        
        if let accessToken = accessToken {
            httpHeaders = HTTPHeaders([.accept("*/*"),
                                       .authorization(bearerToken: accessToken)])
        }
        
        if let cityCode = cityCode {
            parameters = [URLQueryItem(name: "id", value: String(cityCode))]
        }
        
        let data = try await Network.shared.request(target: TownLocationRequest(HTTPHeaders: httpHeaders,
                                                                                parameters: parameters))
        return data.body
    }
}
