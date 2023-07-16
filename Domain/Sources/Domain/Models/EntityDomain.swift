//
//  File.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public enum EntityDomain {
    case light
    case `switch`
}

public enum EntityState {
    case on
    case off
}

public enum EntityService {
    case turnOn
    case turnOff
}
