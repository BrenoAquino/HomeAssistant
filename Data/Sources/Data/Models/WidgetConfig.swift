//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Foundation

public struct WidgetConfig: Codable {

    public let id: String
    public let uiType: String
    public let entityID: String
    public let customInfo: WidgetCustomInfo
}
