//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/25.
//

import Foundation

extension URLComponents {
    init<T: Request>(target: T) {
        let targetPath = target.path
        if targetPath.isEmpty {
            guard let components = URLComponents(string: target.baseURL) else { fatalError() }
            self = components
        } else {
            guard let components = URLComponents(string: target.baseURL + target.path) else { fatalError() }
            self = components
        }
    }
}
