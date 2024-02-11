//
//  WebSocketMessageHeader.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct WebSocketMessageHeader: Decodable {
    /// Message ID
    public let id: Int?
    /// Type of the message received
    public let type: WebSocketMessageType
}
