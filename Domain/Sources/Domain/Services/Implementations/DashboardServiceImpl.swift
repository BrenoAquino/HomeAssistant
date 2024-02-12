//
//  DashboardServiceImpl.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

public class DashboardServiceImpl {
    // MARK: Subjects

    @Published public private(set) var dashboards: [String: Dashboard] = [:]
    @Published public private(set) var dashboardOrder: [String] = []

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
        let dashboardsSorted = dashboardOrder.compactMap { dashboards[$0] }
        try await dashboardRepository.save(dashboards: dashboardsSorted)
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl: DashboardService {
    public var dashboardOrderPublisher: AnyPublisher<[String], Never> {
        $dashboardOrder.eraseToAnyPublisher()
    }
    
    public var dashboardsPublisher: AnyPublisher<[String: Dashboard], Never> {
        $dashboards.eraseToAnyPublisher()
    }
    
    public func load() async throws {
        let fetchedDashboards = (try? await dashboardRepository.fetchDashboards()) ?? []
        dashboards = fetchedDashboards.reduce(into: [:], { $0[$1.name] = $1 })
        dashboardOrder = fetchedDashboards.map { $0.name }
    }

    public func add(dashboard: Dashboard) throws {
        guard dashboards[dashboard.name] == nil else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        dashboards[dashboard.name] = dashboard
        dashboardOrder.append(dashboard.name)

        Task { try? await persist() }
    }

    public func delete(dashboardName: String) {
        dashboards[dashboardName] = nil
        dashboardOrder.removeAll(where: { $0 == dashboardName })

        Task { try? await persist() }
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        guard dashboards[dashboardName] != nil else {
            throw DashboardServiceError.dashboardDoesNotExist
        }
        if dashboardName != dashboard.name, dashboards[dashboard.name] != nil {
            throw DashboardServiceError.dashboardAlreadyExists
        }

        dashboards[dashboardName] = dashboard
        if dashboardName != dashboard.name, let index = dashboardOrder.firstIndex(of: dashboardName) {
            dashboardOrder[index] = dashboard.name
        }

        Task { try? await persist() }
    }

    public func update(order: [String]) throws {
        let dashboardNames = dashboards.values.map { $0.name }
        guard
            order.count == dashboardNames.count,
            Set(order) == Set(dashboardNames)
        else {
            throw DashboardServiceError.invalidDashboardOrder
        }

        dashboardOrder = order

        Task { try? await persist() }
    }
}
