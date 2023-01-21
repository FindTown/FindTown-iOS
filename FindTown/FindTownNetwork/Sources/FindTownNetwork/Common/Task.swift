//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public enum Task {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
}
