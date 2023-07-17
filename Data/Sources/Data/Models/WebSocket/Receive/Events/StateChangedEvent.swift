//
//  Event.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct StateChangedEvent: Decodable {

    let eventType: String
    let oldState: GenericEntity
    let newState: GenericEntity

    enum CodingKeys: String, CodingKey {
        case oldState = "old_state"
        case newState = "new_state"
        case eventType = "event_type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventType = try container.decode(String.self, forKey: .eventType)
        self.oldState = try container.decode(GenericEntity.self, forKey: .oldState)
        self.newState = try container.decode(GenericEntity.self, forKey: .newState)
    }
}
