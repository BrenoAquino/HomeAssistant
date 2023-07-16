//
//  UnsubscribeMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

struct UnsubscribeMessage: Encodable {

    let type: WebSocketMessageType = .unsubscribeToEvents
    let subscription: Int
}
