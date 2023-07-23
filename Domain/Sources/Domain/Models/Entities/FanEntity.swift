//
//  FanEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct FanEntity: Entity {

    public let id: String
    public let name: String
    public let domain: EntityDomain = .fan
    public let percentageStep: Double?
    public var percentage: Double?
    public var state: EntityState

    public init(id: String, name: String, percentageStep: Double?, percentage: Double?, state: EntityState) {
        self.id = id
        self.name = name
        self.percentageStep = percentageStep
        self.state = state
        self.percentage = percentage
    }
}

// MARK: - Equatable

extension FanEntity {
    public static func == (lhs: FanEntity, rhs: FanEntity) -> Bool {
        lhs.id == rhs.id
    }
}
