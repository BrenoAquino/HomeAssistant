//
//  CallServiceMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Foundation

struct CallServiceMessage<T: Encodable>: Encodable {
    /// WebSocket message type
    let type: WebSocketMessageType = .callService
    /// Domain for the service
    let domain: String
    /// Command to execute
    let service: String
    /// Entity to suffer the command
    let entityID: String?
    /// Required data to run the command requested
    let serviceData: T?

    enum CodingKeys: String, CodingKey {
        case type, domain, service, target
        case serviceData = "service_data"

        enum TargetCodingKeys: String, CodingKey {
            case entityID = "entity_id"
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var targetContainer = container.nestedContainer(keyedBy: CodingKeys.TargetCodingKeys.self, forKey: .target)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(domain, forKey: .domain)
        try container.encodeIfPresent(service, forKey: .service)
        try container.encodeIfPresent(serviceData, forKey: .serviceData)
        try targetContainer.encodeIfPresent(entityID, forKey: .entityID)
    }
}
