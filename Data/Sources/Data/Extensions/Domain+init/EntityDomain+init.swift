//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Common
import Domain
import Foundation

extension Domain.EntityDomain {
    enum EntityDomainConverterError: Error {
        case missingDomain
    }

    init(entityID: String) throws {
        switch try EntityReader.extractDomain(entityID) {
        case "light":
            self = .light
        case "fan":
            self = .fan
        case "climate":
            self = .climate
        case "switch":
            self = .switch
        default:
            throw EntityDomainConverterError.missingDomain
        }
    }
}
