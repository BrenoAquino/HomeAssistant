//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Foundation

public struct WidgetConfig: Codable {
    /// Unique identifier
    public let id: String
    /// An identification for which widget it is
    public let uiType: String
    /// Entity that the widget would represent
    public let entityID: String
    /// Custom information to override entity information for this widget
    public let customInfo: WidgetCustomInfo
}
