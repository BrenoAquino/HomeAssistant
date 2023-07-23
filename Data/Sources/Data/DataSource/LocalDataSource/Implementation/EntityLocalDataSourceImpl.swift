//
//  EntityLocalDataSourceImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public class EntityLocalDataSourceImpl {

    private static let hiddenEntityIDsKey = "HIDDEN_ENTITY_IDS"

    private let databaseProvider: DatabaseProvider

    public init(databaseProvider: DatabaseProvider) {
        self.databaseProvider = databaseProvider
    }
}

// MARK: - EntityLocalDataSource

extension EntityLocalDataSourceImpl: EntityLocalDataSource {
    public func hiddenEntityIDs() async throws -> [String] {
        try await databaseProvider.load(key: Self.hiddenEntityIDsKey)
    }

    public func save(hiddenEntityIDs: [String]) async throws {
        try await databaseProvider.save(key: Self.hiddenEntityIDsKey, data: hiddenEntityIDs)
    }
}
