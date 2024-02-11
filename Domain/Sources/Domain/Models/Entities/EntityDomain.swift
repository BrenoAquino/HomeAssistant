//
//  EntityDomain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public enum EntityActionService {
    case turnOn
    case turnOff
}

public enum EntityDomain: CaseIterable {
    case light
    case `switch`
    case fan
    case climate
}
