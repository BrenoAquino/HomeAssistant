//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

extension WidgetConfig {
    static func mock(entity: any Entity, uiType: String = "default") -> Self {
        .init(
            id: entity.id + "_widget",
            entityID: entity.id,
            uiType: uiType,
            customInfo: .init(
                title: entity.name + " Custom"
            )
        )
    }
}
//#endif
