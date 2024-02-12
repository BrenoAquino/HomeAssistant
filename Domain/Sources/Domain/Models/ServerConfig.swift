//
//  ServerConfig.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public enum ServerState {
    /// Online
    case online
    /// Offline
    case offline
}

public struct ServerConfig {
    /// Name of the server's location
    public let locationName: String
    /// Current server state
    public let state: ServerState

    public init(locationName: String, state: ServerState) {
        self.locationName = locationName
        self.state = state
    }
}
