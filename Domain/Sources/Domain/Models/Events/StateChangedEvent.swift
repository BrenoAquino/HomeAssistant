//
//  StateChangedEvent.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct StateChangedEvent {

    public let id: String
    public let domain: EntityDomain
    public let name: String
    public let oldState: String
    public let newState: String

    public init(id: String, domain: EntityDomain, name: String, oldState: String, newState: String) {
        self.id = id
        self.domain = domain
        self.name = name
        self.oldState = oldState
        self.newState = newState
    }
}
