//
//  CommandRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Common
import Foundation

public protocol CommandRepository {

    func fireEvent<T: Encodable>(eventType: String, eventData: T?) async throws
    func callService<T: Encodable>(domain: EntityDomain, service: EntityActionService, entityID: String?, serviceData: T?) async throws
}

extension CommandRepository {

    func fireEvent<T: Encodable>(eventType: String, eventData: T? = EmptyCodable.nil) async throws {}
    func callService<T: Encodable>(
        domain: EntityDomain,
        service: EntityActionService,
        entityID: String?,
        serviceData: T? = EmptyCodable.nil
    ) async throws {}
}
