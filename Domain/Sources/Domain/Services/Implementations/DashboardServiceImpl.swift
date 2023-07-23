//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

public class DashboardServiceImpl {

    @Published public var dashboards: [Dashboard] = []

    private let dashboardRepository: DashboardRepository

    public init(dashboardRepository: DashboardRepository) {
        self.dashboardRepository = dashboardRepository
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl: DashboardService {

    public func trackDashboards() async throws {
        let fetchedDashboards = try? await dashboardRepository.fetchDashboards()
        dashboards = fetchedDashboards ?? []
    }

    public func persist() async throws {
        try await dashboardRepository.save(dashboard: dashboards)
    }

    public func add(dashboard: Dashboard) throws {
        guard dashboards.first(where: { $0.name == dashboard.name }) == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        dashboards.append(dashboard)
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        guard let index = dashboards.firstIndex(where: { $0.name == dashboardName }) else {
            throw DashboardServiceError.dashboardDoesNotExist
        }
        delete(dashboardName: dashboardName)
        guard dashboards.first(where: { $0.name == dashboard.name }) == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        dashboards.insert(dashboard, at: index)
    }

    public func delete(dashboardName: String) {
        dashboards.removeAll(where: { $0.name == dashboardName })
    }

    public func updateAll(dashboards: [Dashboard]) {
        self.dashboards = dashboards
    }
}
