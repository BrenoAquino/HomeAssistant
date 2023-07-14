//
//  WebSocketMessage.swift
//  
//
//  Created by Breno Aquino on 13/07/23.
//

import Foundation

public protocol WebSocketMessage {
    /// Command ID
    var id: Int? { get }
    /// Type
    var type: WebSocketMessageType { get }
}
