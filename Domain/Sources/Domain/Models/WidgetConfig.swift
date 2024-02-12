//
//  WidgetConfig.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Foundation

public struct WidgetConfig {
    /// Widget unique identifier
    public let id: String
    /// Entity to be represented by the widget
    public let entityID: String
    /// Identify for the ui variation
    public let uiType: String
    /// Information to override entity metadata when show the widget
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
