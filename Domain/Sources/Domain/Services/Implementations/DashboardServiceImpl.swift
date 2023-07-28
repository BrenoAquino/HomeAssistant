//
//  DashboardServiceImpl.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

public class DashboardServiceImpl {

    // MARK: Variables

    private var cachedOrder: [String] = []
    private var cachedDashboards: [String : Dashboard] = [:]

    // MARK: Subjects

    public private(set) var dashboardOrder: CurrentValueSubject<[String], Never> = .init([])
    public private(set) var dashboards: CurrentValueSubject<[String : Dashboard], Never> = .init([:])

    // MARK: Repositories

    private let dashboardRepository: DashboardRepository

    // MARK: Init

    public init(dashboardRepository: DashboardRepository) {
        self.dashboardRepository = dashboardRepository
    }
}

// MARK: - Private Methods

extension DashboardServiceImpl {

    private func persist() async throws {
        let dashboardsSorted = cachedOrder.compactMap { cachedDashboards[$0] }
        try await dashboardRepository.save(dashboard: dashboardsSorted)
        let saveLog = dashboardsSorted.map { "\($0.name) (\($0.widgets.count) devices)" }.joined(separator: ", ")
        Logger.log(level: .info, "Saved \(saveLog)")
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl: DashboardService {

    public func load() async throws {
        let fetchedDashboards = (try? await dashboardRepository.fetchDashboards()) ?? []
        cachedDashboards = fetchedDashboards.reduce(into: [:], { $0[$1.name] = $1 })
        cachedOrder = fetchedDashboards.map { $0.name }

        dashboards.send(cachedDashboards)
        dashboardOrder.send(cachedOrder)
    }

    public func add(dashboard: Dashboard) throws {
        guard cachedDashboards[dashboard.name] == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        cachedDashboards[dashboard.name] = dashboard
        cachedOrder.append(dashboard.name)

        dashboards.send(cachedDashboards)
        dashboardOrder.send(cachedOrder)

        Task { try? await persist() }
    }

    public func delete(dashboardName: String) {
        cachedDashboards[dashboardName] = nil
        cachedOrder.removeAll(where: { $0 == dashboardName })

        dashboards.send(cachedDashboards)
        dashboardOrder.send(cachedOrder)

        Task { try? await persist() }
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        guard cachedDashboards[dashboardName] != nil else {
            throw DashboardServiceError.dashboardDoesNotExist
        }
        if dashboardName != dashboard.name, cachedDashboards[dashboard.name] != nil {
            throw DashboardServiceError.dashboardAlreadyExists
        }

        cachedDashboards[dashboardName] = dashboard
        dashboards.send(cachedDashboards)

        if dashboardName != dashboard.name, let index = cachedOrder.firstIndex(of: dashboardName) {
            cachedOrder[index] = dashboard.name
            dashboardOrder.send(cachedOrder)
        }

        Task { try? await persist() }
    }

    public func update(order: [String]) throws {
        let dashboardNames = cachedDashboards.values.map { $0.name }
        guard
            order.count == dashboardNames.count,
            Set(order) == Set(dashboardNames)
        else {
            throw DashboardServiceError.invalidDashboardOrder
        }

        cachedOrder = order
        dashboardOrder.send(cachedOrder)

        Task { try? await persist() }
    }
}
