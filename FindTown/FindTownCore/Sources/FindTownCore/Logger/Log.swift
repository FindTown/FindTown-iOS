//
//  File.swift
//  
//
//  Created by 이호영 on 2023/01/27.
//

import Foundation
import OSLog

public struct Log {
    enum Level {
        case debug
        case info
        case network
        case error
        case custom(categoryName: String)

        fileprivate var categoryString: String {
            switch self {
            case .debug:
                return "🐛"
            case .info:
                return "‼️"
            case .network:
                return "💬"
            case .error:
                return "⚠️"
            case .custom(let categoryName):
                return categoryName
            }
        }

        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
            case .error:
                return OSLog.error
            case .custom:
                return OSLog.debug
            }
        }

        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .network:
                return .default
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }

    static func log(_ message: Any,
                    _ arguments: [Any],
                    level: Level,
                    file: StaticString,
                    function: StaticString,
                    line: Int
    ) {
        let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " \n")
        let logger = Logger(subsystem: OSLog.bundleId, category: level.categoryString)
        let logMessage = "\(file) \(line) \(function) \n \(message) \n \(extraMessage) \t\t"
        switch level {
        case .debug,
             .custom:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .network:
            logger.log("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        }
    }
}

extension Log {
    public static func debug(_ message: Any,
                             _ arguments: Any...,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: Int = #line
    ) {
        log(message, arguments, level: .debug, file: file, function: function, line: line)
    }

    public static func info(_ message: Any,
                            _ arguments: Any...,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: Int = #line
    ) {
        log(message, arguments, level: .info, file: file, function: function, line: line)
    }

    public static func network(_ message: Any,
                            _ arguments: Any...,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: Int = #line
    ) {
        log(message, arguments, level: .debug, file: file, function: function, line: line)
    }

    public static func error(_ error: Error,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: Int = #line
    ) {
        log("Error 👇", [error], level: .error, file: file, function: function, line: line)
    }

    public static func custom(category: String,
                              _ message: Any,
                              _ arguments: Any...,
                              file: StaticString = #file,
                              function: StaticString = #function,
                              line: Int = #line
    ) {
        log(message, arguments, level: .custom(categoryName: category), file: file, function: function, line: line)
    }
}
