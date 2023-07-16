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
        case state, name
        case id = "entity_id"
    }
}
