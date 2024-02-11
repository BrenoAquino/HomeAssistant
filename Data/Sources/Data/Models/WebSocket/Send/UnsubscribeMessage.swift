//
//  UnsubscribeMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

struct UnsubscribeMessage: Encodable {
    /// WebSocket message type
    let type: WebSocketMessageType = .unsubscribeToEvents
    /// Subscription ID to cancel
    let subscription: Int
}
