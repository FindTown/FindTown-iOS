//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation
import FindTownNetwork

public protocol BaseRequest: Request { }

public extension BaseRequest {
    var baseURL: String {
        return Bundle.main.FIND_TOWN_SERVER_URL
    }
}
