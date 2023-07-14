//
//  Logger.swift
//  Home
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation
import Common
import os

class Logger: CommonLogger {
#if DEBUG
    static var logger: OSLog = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Home.App"
    )
#endif
}
