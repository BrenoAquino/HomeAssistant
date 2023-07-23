//
//  StateChangedEvent.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct StateChangedEvent: Decodable {

    let eventType: String
    let entityID: String
    let oldState: GenericEntity
    let newState: GenericEntity

    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case data

        enum DataCodingKeys: String, CodingKey {
            case entityID = "entity_id"
            case oldState = "old_state"
            case newState = "new_state"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataCodingKeys.self, forKey: .data)
        self.eventType = try container.decode(String.self, forKey: .eventType)
        self.entityID = try dataContainer.decode(String.self, forKey: .entityID)
        self.oldState = try dataContainer.decode(GenericEntity.self, forKey: .oldState)
        self.newState = try dataContainer.decode(GenericEntity.self, forKey: .newState)
    }
}
