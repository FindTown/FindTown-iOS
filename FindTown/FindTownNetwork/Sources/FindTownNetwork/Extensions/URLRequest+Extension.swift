//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation
import FindTownCore

extension URLRequest {
    mutating func encoded(encodable: Encodable,
                          encoder: JSONEncoder = JSONEncoder()
    ) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            let body = try encoder.encode(encodable)
            Log.info(String(data: body, encoding: .utf8))
            httpBody = body
            return self
        } catch {
            throw FTNetworkError.encode
        }
    }
}
