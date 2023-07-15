//
//  StateRemoteDataSourceImpl.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public class StateRemoteDataSourceImpl {

    let webSocketProvider: WebSocketProvider

    public init(webSocketProvider: WebSocketProvider) {
        self.webSocketProvider = webSocketProvider
    }
}

// MARK: - StateRemoteDataSource

extension StateRemoteDataSourceImpl: StateRemoteDataSource {

    public func subscribeToStateChanged() async throws {
        try await webSocketProvider.send(message: SubscribeToStateChanged())
    }

    public func fetchStates() async throws -> [EntityState] {
        try await webSocketProvider.send(message: FetchStateMessage())
    }
}
