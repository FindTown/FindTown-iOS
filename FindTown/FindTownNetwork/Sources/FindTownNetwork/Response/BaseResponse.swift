//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

public struct BaseResponse<ResponseType: Response>: Response {
    public let header: Header
    public let body: ResponseType
}

public struct Header: Response {
    public let code: Int
    public let message: String
}


