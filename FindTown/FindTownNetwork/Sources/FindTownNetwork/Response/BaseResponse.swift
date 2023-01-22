//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

struct BaseResponse<ResponseType: Response>: Response {
    let header: Header
    let body: ResponseType
}

struct Header: Response {
    let code: Int
    let message: String
}


