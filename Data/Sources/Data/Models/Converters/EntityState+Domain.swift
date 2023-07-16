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

// MARK: EntityDomain+init

private extension Domain.EntityDomain {

    init(id: String) throws {
        guard let domainInName = id.split(separator: ".").first else {
            throw ConverterError("Domain.EntityDomain.init: Could not extract domain in the ID")
        }
        switch String(domainInName) {
        case "light":
            self = .light
        case "switch":
            self = .switch
        default:
            throw ConverterError("Domain.EntityDomain.init: Could not recognize the domain")
        }
    }
}

// MARK: EntityState+init

private extension Domain.EntityState {

    init(rawValue: String) throws {
        switch rawValue {
        case "on":
            self = .on
        case "off":
            self = .off
        default:
            throw ConverterError("Domain.EntityState.init: Could not recognize the domain")
        }
    }
}
