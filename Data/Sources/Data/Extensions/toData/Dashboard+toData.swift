//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.Dashboard {
    func toData() -> Dashboard {
        Dashboard(
            name: name,
            icon: icon,
            columns: columns,
            widgetConfigs: widgetConfigs.map { WidgetConfig(
                id: $0.id,
                uiType: $0.uiType,
                entityID: $0.entityID,
                customInfo: $0.customInfo.toData()
            )}
        )
    }
}
