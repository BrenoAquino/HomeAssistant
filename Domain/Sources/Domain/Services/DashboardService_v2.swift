//
//  DashboardService.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

public protocol DashboardService_v2 {

    var dashboards: CurrentValueSubject<[Dashboard], Never> { get }

    func load() async throws
    func persist() async throws

    func add(dashboard: Dashboard) throws
    func delete(dashboardName: String) throws

    func update(dashboardName: String, dashboard: Dashboard) throws
    func updateAll(dashboards: [Dashboard])
}

public class DashboardServiceImpl_v2 {

    // MARK: Variables

    private var cachedDashboards: [Dashboard] = []

    // MARK: Subjects

    public private(set) var dashboards: CurrentValueSubject<[Dashboard], Never> = .init([])

    // MARK: Repositories

    private let dashboardRepository: DashboardRepository

    // MARK: Init

    public init(dashboardRepository: DashboardRepository) {
        self.dashboardRepository = dashboardRepository
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl_v2: DashboardService_v2 {

    public func load() async throws {
        let fetchedDashboards = try? await dashboardRepository.fetchDashboards()
        cachedDashboards = fetchedDashboards ?? []
        dashboards.send(cachedDashboards)
    }

    public func persist() async throws {
        try await dashboardRepository.save(dashboard: cachedDashboards)
        let saveLog = cachedDashboards.map { "\($0.name) (\($0.entitiesIDs.count) devices)" }.joined(separator: ", ")
        Logger.log(level: .info, "Saved \(saveLog)")
    }

    public func add(dashboard: Dashboard) throws {
        guard cachedDashboards.first(where: { $0.name == dashboard.name }) == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        cachedDashboards.append(dashboard)
        dashboards.send(cachedDashboards)
    }

    public func delete(dashboardName: String) {
        cachedDashboards.removeAll(where: { $0.name == dashboardName })
        dashboards.send(cachedDashboards)
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        guard let index = cachedDashboards.firstIndex(where: { $0.name == dashboardName }) else {
            throw DashboardServiceError.dashboardDoesNotExist
        }
        if dashboardName != dashboard.name, cachedDashboards.contains(where: { $0.name == dashboard.name }) {
            throw DashboardServiceError.dashboardAlreadyExists
        }

        cachedDashboards.removeAll(where: { $0.name == dashboardName })
        cachedDashboards.insert(dashboard, at: index)
        dashboards.send(cachedDashboards)
    }

    public func updateAll(dashboards: [Dashboard]) {
        cachedDashboards = dashboards
        self.dashboards.send(cachedDashboards)
    }
}
