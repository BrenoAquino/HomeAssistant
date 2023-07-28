//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import Domain
import Foundation

extension EntityWidget {

    func toDomain() -> Domain.EntityWidget {
        Domain.EntityWidget(entityID: entityID, uiType: uiType)
    }
}
