//
//  CommandRepositoryImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Domain
import Foundation

public class CommandRepositoryImpl {

    private let commandRemoteDataSource: CommandRemoteDataSource

    public init(commandRemoteDataSource: CommandRemoteDataSource) {
        self.commandRemoteDataSource = commandRemoteDataSource
    }
}

// MARK: - CommandRepository

extension CommandRepositoryImpl: CommandRepository {

    public func fireEvent<T: Encodable>(eventType: String, eventData: T? = EmptyCodable.nil) async throws {
        try await commandRemoteDataSource.fireEvent(eventType: eventType, eventData: eventData)
    }

    public func callService<T: Encodable>(
        entityID: String,
        service: EntityActionService,
        serviceData: T?
    ) async throws {
        try await commandRemoteDataSource.callService(
            domain: try Domain.EntityDomain(id: entityID).string,
            service: service.string,
            entityID: entityID,
            serviceData: serviceData
        )
    }

    public func callService<T: Encodable>(
        domain: EntityDomain,
        service: EntityActionService,
        serviceData: T?
    ) async throws {
        try await commandRemoteDataSource.callService(
            domain: domain.string,
            service: service.string,
            entityID: nil,
            serviceData: serviceData
        )
    }
}
