//
//  FireEventMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Foundation

struct FireEventMessage<T: Encodable>: Encodable {

    let type: WebSocketMessageType = .fireEvent
    let eventType: String
    let eventData: T?

    enum CodingKeys: String, CodingKey {
        case type
        case eventType = "event_type"
        case eventData = "event_data"
    }
}

extension FireEventMessage where T == EmptyCodable {

    init(eventType: String) {
        self.eventType = eventType
        eventData = nil
    }
}
