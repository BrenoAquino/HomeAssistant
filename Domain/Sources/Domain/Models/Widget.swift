//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Foundation

public struct Widget {

    public let entityID: String
    public let uiType: String

    public init(entityID: String, uiType: String) {
        self.entityID = entityID
        self.uiType = uiType
    }
}
