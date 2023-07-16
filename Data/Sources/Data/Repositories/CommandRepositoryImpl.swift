//
//  CommandRepositoryImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

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

    public func fireEvent(eventType: String) async throws {
        try await commandRemoteDataSource.fireEvent(eventType: eventType)
    }

    public func fireEvent<T: Encodable>(eventType: String, eventData: T) async throws {
        try await commandRemoteDataSource.fireEvent(eventType: eventType, eventData: eventData)
    }

    public func callService(domain: EntityDomain, service: EntityService, entityID: String?) async throws {
        try await commandRemoteDataSource.callService(
            domain: domain.string,
            service: service.string,
            entityID: entityID
        )
    }

    public func callService<T: Encodable>(domain: EntityDomain, service: EntityService, entityID: String?, serviceData: T) async throws {
        try await commandRemoteDataSource.callService(
            domain: domain.string,
            service: service.string,
            entityID: entityID,
            serviceData: serviceData
        )
    }
}
