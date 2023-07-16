//
//  SetStateMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct SetStateMessage: Encodable {

    let type: WebSocketMessageType = .callService
    let domain: String
    let service: String
    let entityID: String

    enum CodingKeys: String, CodingKey {
        case type, domain, service, target

        enum TargetCodingKeys: String, CodingKey {
            case entityID = "entity_id"
        }
    }

    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        var targetContainer = rootContainer.nestedContainer(keyedBy: CodingKeys.TargetCodingKeys.self, forKey: .target)
        try rootContainer.encode(type, forKey: .type)
        try rootContainer.encode(domain, forKey: .domain)
        try rootContainer.encode(service, forKey: .service)
        try targetContainer.encode(entityID, forKey: .entityID)
    }
}
