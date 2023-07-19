//
//  DomainEntityDomain+init.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension Domain.EntityDomain {

    var string: String {
        switch self {
        default:
            return String(describing: self)
        }
    }

    init(id: String) throws {
        guard let domainInName = id.split(separator: ".").first else {
            throw ConverterError("Domain.EntityDomain.init: Could not extract domain in the ID")
        }
        switch String(domainInName) {
        case Self.light.string: self = .light
        case Self.switch.string: self = .switch
        case Self.climate.string: self = .climate
        case Self.fan.string: self = .fan
        default: throw ConverterError("Domain.EntityDomain.init: Could not recognize the domain")
        }
    }
}
