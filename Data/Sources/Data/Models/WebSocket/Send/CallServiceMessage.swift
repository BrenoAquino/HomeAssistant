//
//  CallServiceMessage.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Foundation

struct CallServiceMessage<T: Encodable>: Encodable {

    let type: WebSocketMessageType = .callService
    let domain: String
    let service: String
    let entityID: String?
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
        try container.encode(type, forKey: .type)
        try container.encode(domain, forKey: .domain)
        try container.encode(service, forKey: .service)
        try container.encode(serviceData, forKey: .serviceData)
        try targetContainer.encode(entityID, forKey: .entityID)
    }
}
