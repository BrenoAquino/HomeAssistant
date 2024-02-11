//
//  ServerRepositoryImpl.swift
//
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

public class ServerRepositoryImpl {

    private let fetcherRemoteDataSource: FetcherRemoteDataSource

    public init(fetcherRemoteDataSource: FetcherRemoteDataSource) {
        self.fetcherRemoteDataSource = fetcherRemoteDataSource
    }
}

// MARK: - ServerRepository

extension ServerRepositoryImpl: ServerRepository {

    public func fetchConfig() async throws -> Domain.ServerConfig {
        try await fetcherRemoteDataSource.fetchServerConfig().toDomain()
    }
}
