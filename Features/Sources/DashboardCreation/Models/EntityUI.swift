//
//  EntityUI.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Domain
import Foundation

public struct EntityUI {

    let id: String
    let name: String
    let domainUI: EntityDomainUI
}

extension Entity {
    func toUI() -> EntityUI {
        EntityUI(id: id, name: name, domainUI: domain)
    }
}
