//
//  File 2.swift
//  
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation
import OSLog

extension OSLog {
    static let bundleId = "kr.FindTown.com"
    static let network = OSLog(subsystem: bundleId, category: "Network")
    static let debug = OSLog(subsystem: bundleId, category: "Debug")
    static let info = OSLog(subsystem: bundleId, category: "Info")
    static let error = OSLog(subsystem: bundleId, category: "Error")
}
