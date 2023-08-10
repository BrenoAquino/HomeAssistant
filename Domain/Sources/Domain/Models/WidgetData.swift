//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Foundation

public struct WidgetData {

    public var config: WidgetConfig
    public var entity: any Entity

    public init(config: WidgetConfig, entity: any Entity) {
        self.config = config
        self.entity = entity
    }
}

// MARK: - Hashable

extension WidgetData: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(config.id)
    }

    public static func == (lhs: WidgetData, rhs: WidgetData) -> Bool {
        lhs.config.id == rhs.config.id
    }
}
