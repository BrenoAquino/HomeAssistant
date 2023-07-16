//
//  CommandRemoteDataSourceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Foundation

public class CommandRemoteDataSourceImpl {

    private let webSocketProvider: WebSocketProvider

    public init(webSocketProvider: WebSocketProvider) {
        self.webSocketProvider = webSocketProvider
    }
}

// MARK: - CommandRemoteDataSource

extension CommandRemoteDataSourceImpl: CommandRemoteDataSource {

    public func fireEvent(eventType: String) async throws {
        try await fireEvent(eventType: eventType, eventData: EmptyCodable.nil)
    }

    public func fireEvent<T: Encodable>(eventType: String, eventData: T?) async throws {
        try await webSocketProvider.send(message: FireEventMessage(eventType: eventType, eventData: eventData))
    }

    public func callService(domain: String, service: String, entityID: String?) async throws {
        try await callService(domain: domain, service: service, entityID: entityID, serviceData: EmptyCodable.nil)
    }

    public func callService<T: Encodable>(domain: String, service: String, entityID: String?, serviceData: T?) async throws {
        try await webSocketProvider.send(message: CallServiceMessage(
            domain: domain,
            service: service,
            entityID: entityID,
            serviceData: serviceData
        ))
    }
}
