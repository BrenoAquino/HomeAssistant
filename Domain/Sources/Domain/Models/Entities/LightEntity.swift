//
//  LightEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct LightEntity: Entity {

    public let id: String
    public let name: String
    public let domain: EntityDomain = .light
    public var state: EntityState

    public init(id: String, name: String, state: EntityState) {
        self.id = id
        self.name = name
        self.state = state
    }
}

// MARK: - Equatable

extension LightEntity {
    public static func == (lhs: LightEntity, rhs: LightEntity) -> Bool {
        lhs.id == rhs.id
    }
}
