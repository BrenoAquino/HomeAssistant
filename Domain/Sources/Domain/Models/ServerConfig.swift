//
//  ServerConfig.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public enum ServerState {
    case online
    case offline
}

public class ServerConfig {

    public let locationName: String
    public let state: ServerState

    public init(locationName: String, state: ServerState) {
        self.locationName = locationName
        self.state = state
    }
}
