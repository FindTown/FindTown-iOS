//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

extension URL {
    init<T: RequestType>(target: T) {
        let targetPath = target.path
        if targetPath.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(targetPath)
        }
    }
}
