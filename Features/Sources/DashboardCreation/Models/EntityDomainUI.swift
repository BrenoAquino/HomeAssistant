//
//  File.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Domain
import Foundation

protocol EntityDomainUI {

    var name: String { get }
    var icon: String { get }
}

extension EntityDomain: EntityDomainUI {
    var name: String {
        String(describing: self)
    }

    var icon: String {
        switch self {
        case .light:
            return "lightbulb.led"
        case .switch:
            return "lightswitch.on"
        case .fan:
            return "fan.desk"
        case .climate:
            return "air.conditioner.horizontal"
        }
    }
}
