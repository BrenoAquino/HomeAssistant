//
//  FetcherRepositoryImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

public class FetcherRepositoryImpl {

    private let fetcherRemoteDataSource: FetcherRemoteDataSource

    public init(fetcherRemoteDataSource: FetcherRemoteDataSource) {
        self.fetcherRemoteDataSource = fetcherRemoteDataSource
    }
}

// MARK: - FetcherRepository

extension FetcherRepositoryImpl: FetcherRepository {

    public func fetchConfig() async throws -> Domain.ServerConfig {
        try await fetcherRemoteDataSource.fetchConfig().toDomain()
    }

    public func fetchStates() async throws -> [Domain.Entity] {
        try await fetcherRemoteDataSource.fetchStates().compactMap { try? $0.toDomain() }
    }
}
