//
//  EntityState.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct EntityState: Decodable {

    public let id: String
    public let state: String
    public let name: String

    enum CodingKeys: String, CodingKey {
        case state, attributes
        case id = "entity_id"

        enum AttributesCodingKeys: String, CodingKey {
            case name = "friendly_name"
        }
    }

    init(id: String, state: String, name: String) {
        self.id = id
        self.state = state
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let attributesContainer = try container.nestedContainer(keyedBy: CodingKeys.AttributesCodingKeys.self, forKey: .attributes)
        self.id = try container.decode(String.self, forKey: .id)
        self.state = try container.decode(String.self, forKey: .state)
        self.name = try attributesContainer.decode(String.self, forKey: .name)
    }
}
