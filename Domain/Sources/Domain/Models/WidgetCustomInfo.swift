//
//  File.swift
//  
//
//  Created by Breno Aquino on 10/08/23.
//

import Foundation

public struct WidgetCustomInfo {
    /// Widget title
    public var title: String

    public init(title: String) {
        self.title = title
    }
}

// MARK: - Hashable

extension WidgetCustomInfo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
