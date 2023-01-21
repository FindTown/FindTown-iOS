//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

extension URLRequest {
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            httpBody = try encoder.encode(encodable)
            return self
        } catch {
            throw NetworkError.encode
        }
    }
}
