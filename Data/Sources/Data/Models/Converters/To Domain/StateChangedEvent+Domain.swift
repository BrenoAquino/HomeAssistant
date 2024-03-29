//
//  StateChangedEvent+Domain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension StateChangedEvent {

    func toDomain() throws -> Domain.StateChangedEvent {
        guard
            newState.id == oldState.id,
            newState.attributes.name == oldState.attributes.name
        else {
            throw ConverterError("StateChangedEvent.toDomain: Inconsistency between the new and the old state")
        }
        return Domain.StateChangedEvent(
            id: newState.id,
            domain: try Domain.EntityDomain(id: newState.id),
            name: newState.attributes.name,
            oldState: oldState.state,
            newState: newState.state
        )
    }
}
