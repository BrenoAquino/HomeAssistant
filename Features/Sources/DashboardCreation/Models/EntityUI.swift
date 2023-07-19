//
//  EntityUI.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Domain
import Foundation

protocol EntityUI {

    var id: String { get }
    var name: String { get }
    var domainUI: EntityDomainUI { get }
}

extension Entity: EntityUI {
    var domainUI: EntityDomainUI { domain }
}
