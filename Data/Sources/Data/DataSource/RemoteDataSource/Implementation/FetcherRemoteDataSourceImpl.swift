//
//  FetcherRemoteDataSourceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class FetcherRemoteDataSourceImpl {

    private let webSocketProvider: WebSocketProvider

    public init(webSocketProvider: WebSocketProvider) {
        self.webSocketProvider = webSocketProvider
    }
}

// MARK: - FetcherRemoteDataSource

extension FetcherRemoteDataSourceImpl: FetcherRemoteDataSource {

    public func fetchConfig() async throws -> ServerConfig {
        let (_, config): (Int, ServerConfig) = try await webSocketProvider.send(message: FetchConfigMessage())
        return config
    }

    public func fetchStates() async throws -> [EntityState] {
        let (_, states): (Int, [EntityState]) = try await webSocketProvider.send(message: FetchStateMessage())
        return states
    }
}
