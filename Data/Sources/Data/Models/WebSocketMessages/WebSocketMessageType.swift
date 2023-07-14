//
//  WebSocketMessageType.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public enum WebSocketMessageType: String, Codable {
    /// When the server requires an authentication
    case authRequired = "auth_required"
    /// When we send an access token
    case auth
}
