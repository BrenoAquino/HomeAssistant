//
//  Event.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct StateChangedEvent: Decodable {

    let eventType: String
    let oldState: EntityState
    let newState: EntityState

    enum CodingKeys: String, CodingKey {
        case data
        case eventType = "event_type"

        enum DataCodingKeys: String, CodingKey {
            case oldState = "old_state"
            case newState = "new_state"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.self, forKey: .data)
        self.eventType = try container.decode(String.self, forKey: .eventType)
        self.oldState = try dataContainer.decode(EntityState.self, forKey: .oldState)
        self.newState = try dataContainer.decode(EntityState.self, forKey: .newState)
    }
}
