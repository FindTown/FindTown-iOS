//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public enum TaskType {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(encodable: Encodable)
    case requestCustomJSONEncodable(encodable: Encodable, encoder: JSONEncoder)
}
