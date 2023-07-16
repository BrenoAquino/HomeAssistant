//
//  WebSocketMessageType.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public enum WebSocketMessageType: String, Codable {
    /// When the message is a result
    case result
    /// When the server requires an authentication
    case authRequired = "auth_required"
    /// When we send an access token
    case auth
    /// Subscribe to events
    case subscribeToEvents = "subscribe_events"
    /// Call a service
    case callService = "call_service"
    /// Ping
    case ping
    /// Pong
    case pong
    /// Receive an event (e.g. states_changed)
    case event

    // MARK: Fetch
    /// Request all entities states
    case fetchStates = "get_states"
    /// Request server config
    case fetchConfig = "get_config"
}
