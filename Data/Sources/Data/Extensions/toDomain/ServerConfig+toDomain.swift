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
            state: Domain.ServerState(state: state)
        )
    }
}
