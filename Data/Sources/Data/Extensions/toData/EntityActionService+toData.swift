//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.EntityActionService {
    func toData() -> String {
        switch self {
        case .turnOn:
            "turn_on"
        case .turnOff:
            "turn_off"
        }
    }
}
