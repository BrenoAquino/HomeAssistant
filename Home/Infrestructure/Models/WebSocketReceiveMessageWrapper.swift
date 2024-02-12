//
//  File.swift
//  Home
//
//  Created by Breno Aquino on 11/02/24.
//

import Data
import Foundation

struct WebSocketReceiveMessageWrapper<Model: Decodable>: Decodable {
    /// Message type
    public let type: WebSocketMessageType
    /// Whether the command was executed successfully or not
    public let success: Bool
    /// Custom data for each command
    public let result: Model?
}
