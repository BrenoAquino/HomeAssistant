//
//  DomainEntityService+string.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension Domain.EntityService {

    var string: String {
        switch self {
        case .turnOn:
            return "turn_on"
        case .turnOff:
            return "turn_off"
        }
    }
}
