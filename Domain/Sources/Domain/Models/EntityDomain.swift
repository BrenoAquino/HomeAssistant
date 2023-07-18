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
    case fan
    case climate
}
