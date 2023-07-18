//
//  DomainEntityState+init.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension Domain.EntityState {

    var string: String {
        switch self {
        default:
            return String(describing: self)
        }
    }

    init(rawValue: String) throws {
        switch rawValue {
        case Self.on.string: self = .on
        case Self.off.string: self = .off
        default: throw ConverterError("Domain.EntityState.init: Could not recognize the domain")
        }
    }
}
