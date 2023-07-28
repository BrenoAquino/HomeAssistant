//
//  WebSocketMessageHeader.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct WebSocketMessageHeader: Decodable {
    
    public let id: Int?
    public let type: WebSocketMessageType
}
