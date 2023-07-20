//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

public class DashboardServiceImpl {

    public let dashboards: CurrentValueSubject<[Dashboard], Never> = .init([])
    public private(set) var allDashboards: [Dashboard] = [] {
        didSet { dashboards.send(allDashboards) }
    }

    private let entityService: EntityService
    private let dashboardRepository: DashboardRepository

    public init(entityService: EntityService, dashboardRepository: DashboardRepository) {
        self.entityService = entityService
        self.dashboardRepository = dashboardRepository
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl: DashboardService {

    public func trackDashboards() async throws {
        let fetchedDashboards = try? await dashboardRepository.fetchDashboards()
        allDashboards = []

        for dashboard in fetchedDashboards ?? [] {
            dashboard.entities = dashboard.entitiesIDs.compactMap { entityService.entities.value.all[$0] }
            allDashboards.append(dashboard)
        }
    }

    public func persist() async throws {
        try await dashboardRepository.save(dashboard: dashboards.value)
    }

    public func add(dashboard: Dashboard) throws {
        guard allDashboards.first(where: { $0.name == dashboard.name }) == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        allDashboards.append(dashboard)
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        delete(dashboardName: dashboardName)
        try add(dashboard: dashboard)
    }

    public func delete(dashboardName: String) {
        allDashboards.removeAll(where: { $0.name == dashboardName })
    }

    public func updateAll(dashboards: [Dashboard]) {
        allDashboards = dashboards
    }
}
