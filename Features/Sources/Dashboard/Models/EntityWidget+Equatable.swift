//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Domain
import Foundation

extension EntityWidget: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(entityID)
        hasher.combine(uiType)
    }

    public static func == (lhs: EntityWidget, rhs: EntityWidget) -> Bool {
        lhs.entityID == rhs.entityID && lhs.uiType == rhs.uiType
    }
}
