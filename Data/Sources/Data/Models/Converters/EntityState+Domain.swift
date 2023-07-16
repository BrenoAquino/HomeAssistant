//
//  EntityState+Domain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension EntityState {

    func toDomain() throws -> Domain.Entity {
        Domain.Entity(
            id: id,
            name: name,
            domain: try Domain.EntityDomain(id: id),
            state: try Domain.EntityState(rawValue: state)
        )
    }
}
