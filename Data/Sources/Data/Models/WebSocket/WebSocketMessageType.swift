//
//  WebSocketMessageType.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public enum WebSocketMessageType: String, Codable {
    // MARK: Sending
    /// Send the access token to get an authenticated web socket session
    case auth
    /// Request all entities states
    case fetchStates = "get_states"
    /// Request server config
    case fetchConfig = "get_config"
    /// Request to run a service
    case callService = "call_service"
    /// Run an event in the server side
    case fireEvent = "fire_event"
    /// Subscribe to receive messages when some event happens
    case subscribeToEvents = "subscribe_events"
    /// Unsubscribe to receive messages when some event happens
    case unsubscribeToEvents = "unsubscribe_events"
    
    // MARK: Receiving
    /// When the server requires an authentication
    case authRequired = "auth_required"
    /// When the message is a response of a request
    case result
    /// Some thing did happen in the server (e.g. states_changed)
    case event

    // MARK: Health Check
    /// Ping
    case ping
    /// Pong
    case pong
}
