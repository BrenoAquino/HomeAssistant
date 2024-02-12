//
//  WebSocketSendMessageWrapper.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct WebSocketSendMessageWrapper<T: Encodable>: Encodable {

    let id: Int?
    let messageData: T

    enum CodingKeys: CodingKey {
        case id
    }

    init(id: Int, messageData: T) {
        self.id = id
        self.messageData = messageData
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WebSocketSendMessageWrapper<T>.CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: WebSocketSendMessageWrapper<T>.CodingKeys.id)
        try messageData.encode(to: encoder)
    }
}
