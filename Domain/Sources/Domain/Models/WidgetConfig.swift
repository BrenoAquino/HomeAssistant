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
    public let title: String
    public let uiType: String

    public init(
        id: String,
        entityID: String,
        title: String,
        uiType: String = "default"
    ) {
        self.id = id
        self.entityID = entityID
        self.title = title
        self.uiType = uiType
    }
}

// MARK: - Hashable

extension WidgetConfig: Hashable {}
