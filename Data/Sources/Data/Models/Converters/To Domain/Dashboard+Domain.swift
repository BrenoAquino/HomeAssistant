//
//  Dashboard+Domain.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

extension Dashboard {

    func toDomain() -> Domain.Dashboard {
        Domain.Dashboard(
            name: name,
            icon: icon,
            widgetConfigs: widgetConfigs.map { $0.toDomain() }
        )
    }
}
