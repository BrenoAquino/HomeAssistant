//
//  Dashboard.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public struct Dashboard {

    public var name: String
    public var icon: String
    public var columns: Int
    public var widgetConfigs: [WidgetConfig]

    public init(name: String, icon: String, columns: Int, widgetConfigs: [WidgetConfig]) {
        self.name = name
        self.icon = icon
        self.columns = columns
        self.widgetConfigs = widgetConfigs
    }
}

// MARK: - Hashable

extension Dashboard: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    public static func == (lhs: Dashboard, rhs: Dashboard) -> Bool {
        lhs.name == rhs.name
    }
}
