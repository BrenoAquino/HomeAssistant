//
//  DomainEventType+string.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension Domain.EventType {

    var string: String {
        switch self {
        case .stateChanged:
            return "state_changed"
        }
    }
}
