//
//  CommandRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol CommandRepository {

    func fireEvent(eventType: String, eventData: Encodable?) async throws
    func callService(domain: EntityDomain, service: EntityService, entityID: String) async throws
}
