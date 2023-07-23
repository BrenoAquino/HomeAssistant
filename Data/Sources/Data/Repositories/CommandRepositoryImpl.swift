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

    public func callService(entityID: String, service: EntityActionService) async throws {
        switch service {
        case .turnOn, .turnOff:
            try await commandRemoteDataSource.callService(
                domain: try Domain.EntityDomain(id: entityID).string,
                service: service.string,
                entityID: entityID,
                serviceData: EmptyCodable.nil
            )
        }
    }

    public func callService(domain: EntityDomain, service: EntityActionService) async throws {
        switch service {
        case .turnOn, .turnOff:
            try await commandRemoteDataSource.callService(
                domain: domain.string,
                service: service.string,
                entityID: nil,
                serviceData: EmptyCodable.nil
            )
        }
    }
}
