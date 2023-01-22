//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

enum MockData {
    static var rawData =
            """
            {
              "header": {
                "code": 0,
                "message": "string"
              },
              "body": {
                "test": "test"
              }
            }
            """.data(using: .utf8)!
    
    static var bodyData =
            """
              {
                "test": "test"
              }
            """.data(using: .utf8)!
}
