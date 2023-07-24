//
//  SwitchEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct SwitchEntity: Entity {

    public enum State: String {
        case on
        case off
    }

    public let id: String
    public let name: String
    public let domain: EntityDomain = .switch
    public var state: SwitchEntity.State

    public init(id: String, name: String, state: SwitchEntity.State) {
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
