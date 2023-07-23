//
//  SwitchEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct SwitchEntity: Entity {

    public let id: String
    public let name: String
    public let domain: EntityDomain = .switch
    public var state: EntityState

    public init(id: String, name: String, state: EntityState) {
        self.id = id
        self.name = name
        self.state = state
    }
}

// MARK: - Equatable

extension SwitchEntity {
    public static func == (lhs: SwitchEntity, rhs: SwitchEntity) -> Bool {
        lhs.id == rhs.id
    }
}
