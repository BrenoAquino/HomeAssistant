//
//  File.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Domain
import Foundation

public extension EntityDomain {

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
