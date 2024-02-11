//
//  Dashboard.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public struct Dashboard: Codable {
    /// Dashboard's Name
    let name: String
    /// Icon name to represent the dashboard (SFSymbol)
    let icon: String
    /// Number of columns on the dashboard
    let columns: Int
    /// All widgets and its configurations
    let widgetConfigs: [WidgetConfig]
}
