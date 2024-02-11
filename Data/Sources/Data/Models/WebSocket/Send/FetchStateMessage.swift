//
//  FetchStateMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct FetchStateMessage: Encodable {
    /// WebSocket message type
    let type: WebSocketMessageType = .fetchStates
}
