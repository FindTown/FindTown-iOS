//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

extension Data {
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try jsonDecoder.decode(type, from: self)
            return data
        } catch {
            throw NetworkError.decode
        }
    }
}
