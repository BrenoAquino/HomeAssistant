//
//  CommandRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol CommandRepository {

    func fireEvent(eventType: String) async throws
    func fireEvent<T: Encodable>(eventType: String, eventData: T) async throws
    func callService(domain: EntityDomain, service: EntityService, entityID: String?) async throws
    func callService<T: Encodable>(domain: EntityDomain, service: EntityService, entityID: String?, serviceData: T) async throws
}
