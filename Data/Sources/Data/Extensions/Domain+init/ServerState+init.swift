//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.ServerState {
    init(state: String) {
        switch state {
        case "RUNNING":
            self = .online
        default:
            self = .offline
        }
    }
}
