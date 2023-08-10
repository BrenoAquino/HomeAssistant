//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Domain
import Foundation

extension WidgetConfig {

    func toDomain() -> Domain.WidgetConfig {
        Domain.WidgetConfig(id: id, entityID: entityID, uiType: uiType, customInfo: customInfo.toDomain())
    }
}
