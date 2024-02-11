//
//  SubscribeToEventMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct SubscribeToEventMessage: Encodable {
    /// WebSocket message type
    let type: WebSocketMessageType = .subscribeToEvents
    /// Event type to subscribe for
    let eventType: String?

    enum CodingKeys: String, CodingKey {
        case type
        case eventType = "event_type"
    }
}
