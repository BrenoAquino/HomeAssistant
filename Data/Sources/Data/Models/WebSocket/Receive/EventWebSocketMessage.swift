//
//  EventWebSocketMessage.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct EventWebSocketMessage: Decodable {

    public let type: WebSocketMessageType
    /// Whether the command was executed successfully or not
    public let event: Data
}
