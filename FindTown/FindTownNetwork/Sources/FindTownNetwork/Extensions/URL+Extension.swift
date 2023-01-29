//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/22.
//

import Foundation

extension URL {
    init<T: Request>(target: T) {
        let targetPath = target.path
        guard let url = URL(string: target.baseURL) else { fatalError() }
        if targetPath.isEmpty {
            self = url
        } else {
            self = url.appendingPathComponent(targetPath)
        }
    }
}
