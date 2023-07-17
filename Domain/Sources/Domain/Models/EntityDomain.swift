//
//  File.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public enum EntityState {
    case on
    case off
}

public enum EntityActionService {
    case turnOn
    case turnOff
}

public enum EntityDomain: Hashable {
    case light
    case `switch`

    // MARK: States
    var statesAvailable: Set<EntityState> {
        switch self {
        case .light:
            return [.on, .off]
        case .switch:
            return [.on, .off]
        }
    }

    // MARK: Action Services
    var actionServicesAvailable: Set<EntityActionService> {
        switch self {
        case .light:
            return [.turnOn, .turnOff]
        case .switch:
            return [.turnOn, .turnOff]
        }
    }
}
