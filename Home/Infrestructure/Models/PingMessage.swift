//
//  PingMessage.swift
//  Home
//
//  Created by Breno Aquino on 15/07/23.
//

import Data
import Foundation

struct PingMessage: Encodable {
    let type: String = WebSocketMessageType.ping.rawValue
}
