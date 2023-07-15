//
//  AuthenticationMessage.swift
//  Home
//
//  Created by Breno Aquino on 14/07/23.
//

import Data
import Foundation

struct AuthenticationMessage: Encodable {
    let type: String = WebSocketMessageType.auth.rawValue
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case type
        case accessToken = "access_token"
    }
}
