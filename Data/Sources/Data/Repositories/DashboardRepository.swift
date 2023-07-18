//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

public class DashboardRepositoryImpl {

    private let dashboardLocalDataSource: DashboardLocalDataSource
    private var dashboards: [Domain.Dashboard] = []

    public init(dashboardLocalDataSource: DashboardLocalDataSource) {
        self.dashboardLocalDataSource = dashboardLocalDataSource
    }
}

// MARK: - DashboardRepository

extension DashboardRepositoryImpl: Domain.DashboardRepository {

    public func fetchDashboards() async throws -> [Domain.Dashboard] {
        guard dashboards.isEmpty else {
            return dashboards
        }

        dashboards = try await dashboardLocalDataSource.dashboards().map { $0.toDomain() }
        return dashboards
    }

    public func save(dashboard: [Domain.Dashboard]) async throws {
        let data = dashboard.map { $0.toData() }
        try await dashboardLocalDataSource.save(dashboards: data)
    }
}

// MARK: - Domain.Dashboard to Data.Dashboard

extension Domain.Dashboard {

    func toData() -> Dashboard {
        Dashboard(name: name, icon: icon, entities: entities.map { $0.id })
    }
}