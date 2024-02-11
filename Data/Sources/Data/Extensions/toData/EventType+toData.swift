//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.EventType {
    func toData() -> String {
        switch self {
        case .stateChanged:
            "state_changed"
        }
    }
}
