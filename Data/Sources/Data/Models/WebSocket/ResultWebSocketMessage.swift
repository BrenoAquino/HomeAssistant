//
//  ResultWebSocketMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct ResultWebSocketMessage<Model: Decodable>: Decodable {
    
    public var type: WebSocketMessageType
    /// Whether the command was executed successfully or not
    public let success: Bool
    /// Custom data for each command
    public let result: Model?
}
