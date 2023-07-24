//
//  Entity.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol Entity: Hashable {

    associatedtype EntityState: RawRepresentable<String>

    var id: String { get }
    var name: String { get }
    var domain: EntityDomain { get }
    var state: EntityState { get set }
}

extension Entity {

    public func stateUpdated(_ rawState: EntityState.RawValue) -> Self {
        guard let state = EntityState(rawValue: rawState) else { return self }
        var copy = self
        copy.state = state
        return copy
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
