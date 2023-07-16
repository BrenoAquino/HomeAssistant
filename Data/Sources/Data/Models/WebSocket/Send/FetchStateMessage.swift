//
//  FetchStateMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct FetchStateMessage: Encodable {

    let type: WebSocketMessageType = .getStates
}
