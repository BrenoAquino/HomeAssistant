//
//  Logger.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation
import Common
import os

class Logger: CommonLogger {
#if DEBUG
    static var logger: OSLog = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Domain"
    )
#endif
}
