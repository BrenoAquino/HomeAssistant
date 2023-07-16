//
//  FetchConfigMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

struct FetchConfigMessage: Encodable {

    let type: WebSocketMessageType = .fetchConfig
}
