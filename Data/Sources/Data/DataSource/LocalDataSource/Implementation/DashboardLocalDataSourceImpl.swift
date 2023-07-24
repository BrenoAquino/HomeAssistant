//
//  DashboardLocalDataSourceImpl.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public class DashboardLocalDataSourceImpl {

    private static let dashboardsKey = "DASHBOARDS"

    private let databaseProvider: DatabaseProvider

    public init(databaseProvider: DatabaseProvider) {
        self.databaseProvider = databaseProvider
    }
}

// MARK: - DashboardLocalDataSource

extension DashboardLocalDataSourceImpl: DashboardLocalDataSource {

    public func dashboards() async throws -> [Dashboard] {
        try await databaseProvider.load(key: Self.dashboardsKey)
    }

    public func save(dashboards: [Dashboard]) async throws {
        try await databaseProvider.save(key: Self.dashboardsKey, data: dashboards)
    }
}
