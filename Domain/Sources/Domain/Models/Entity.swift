//
//  Entity.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct Entity {

    public let id: String
    public let name: String
    public let domain: EntityDomain
    public let state: EntityState

    public init(id: String, name: String, domain: EntityDomain, state: EntityState) {
        self.id = id
        self.name = name
        self.domain = domain
        self.state = state
    }
}
