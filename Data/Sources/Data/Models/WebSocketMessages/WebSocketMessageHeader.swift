//
//  WebSocketMessageHeader.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct WebSocketMessageHeader: Codable, WebSocketMessage {
    /// Command ID if exists
    public let id: Int?
    /// Request/Response type of message
    public let type: WebSocketMessageType
}
