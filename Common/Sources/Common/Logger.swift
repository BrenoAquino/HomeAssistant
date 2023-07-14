//
//  Logger.swift
//
//
//  Created by Breno Aquino on 22/03/23.
//

import Foundation
import os

public protocol CommonLogger {
    static var logger: OSLog { get }
    static func log(level: OSLogType, _ message: String?, file: String, function: String, line: Int)
}

public extension CommonLogger {

    static var logger: OSLog { .disabled }

    private static func extractFileName(_ file: String) -> String {
        var url: URL?
        if #available(iOS 16.0, *) {
           url = URL(filePath: file)
       } else {
           url = URL(fileURLWithPath: file)
       }
        let fileName = url?.lastPathComponent.prefix(while: { $0 != "." }) ?? String.SubSequence(file)
        return String(fileName)
    }

    static func log(level: OSLogType = .debug, _ message: String?, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = extractFileName(file)
        os_log(
            "%{public}@.%{public}@.L%{public}@ | %{public}@",
            log: logger,
            type: level,
            fileName,
            function,
            String(line),
            message ?? "nil"
        )
    }
}
