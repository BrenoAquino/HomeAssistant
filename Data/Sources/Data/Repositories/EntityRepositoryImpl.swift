//
//  EntityRepositoryImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

public class EntityRepositoryImpl {

    private let entityLocalDataSource: EntityLocalDataSource
    private let fetcherRemoteDataSource: FetcherRemoteDataSource

    public init(entityLocalDataSource: EntityLocalDataSource, fetcherRemoteDataSource: FetcherRemoteDataSource) {
        self.entityLocalDataSource = entityLocalDataSource
        self.fetcherRemoteDataSource = fetcherRemoteDataSource
    }
}

// MARK: - EntityRepository

extension EntityRepositoryImpl: EntityRepository {

    public func save(hiddenEntityIDs: Set<String>) async throws {
        try await entityLocalDataSource.save(hiddenEntityIDs: Array(hiddenEntityIDs))
    }

    public func fetchHiddenEntityIDs() async throws -> Set<String> {
        Set(try await entityLocalDataSource.hiddenEntityIDs())
    }

    public func fetchStates() async throws -> [any Domain.Entity] {
        try await fetcherRemoteDataSource.fetchStates().compactMap { try? $0.toDomain() }
    }
}
