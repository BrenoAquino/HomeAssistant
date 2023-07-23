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
        allDashboards = fetchedDashboards ?? []
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
        guard let index = allDashboards.firstIndex(where: { $0.name == dashboardName }) else {
            throw DashboardServiceError.dashboardDoesNotExist
        }
        delete(dashboardName: dashboardName)
        guard allDashboards.first(where: { $0.name == dashboard.name }) == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        allDashboards.insert(dashboard, at: index)
    }

    public func delete(dashboardName: String) {
        allDashboards.removeAll(where: { $0.name == dashboardName })
    }

    public func updateAll(dashboards: [Dashboard]) {
        allDashboards = dashboards
    }
}
