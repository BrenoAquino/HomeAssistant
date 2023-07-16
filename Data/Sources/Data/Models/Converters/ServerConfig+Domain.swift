//
//  ServerConfig+Domain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension ServerConfig {

    func toDomain() -> Domain.ServerConfig {
        Domain.ServerConfig(
            locationName: locationName,
            state: Domain.ServerState(rawValue: state)
        )
    }
}

// MARK: Domain.ServerState+init

private extension Domain.ServerState {
    init(rawValue: String) {
        switch rawValue {
        case "RUNNING":
            self = .online
        default:
            self = .offline
        }
    }
}
