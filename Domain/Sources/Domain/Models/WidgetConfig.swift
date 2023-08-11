//
//  WidgetConfig.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Foundation

public struct WidgetConfig {

    public let id: String
    public let entityID: String
    public let uiType: String
    public let customInfo: WidgetCustomInfo

    public init(
        id: String,
        entityID: String,
        uiType: String = "default",
        customInfo: WidgetCustomInfo
    ) {
        self.id = id
        self.entityID = entityID
        self.uiType = uiType
        self.customInfo = customInfo
    }
}

// MARK: - Hashable

extension WidgetConfig: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(uiType)
        hasher.combine(customInfo)
    }

    public static func == (lhs: WidgetConfig, rhs: WidgetConfig) -> Bool {
        lhs.id == rhs.id
    }
}
