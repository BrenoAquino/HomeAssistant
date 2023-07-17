//
//  Entity.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public class Entity {

    public let id: String
    public let name: String
    public let domain: EntityDomain
    public var state: EntityState

    public init(id: String, name: String, domain: EntityDomain, state: EntityState) {
        self.id = id
        self.name = name
        self.domain = domain
        self.state = state
    }
}

extension Entity: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}
