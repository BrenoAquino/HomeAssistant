//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public class DashboardServiceImpl {

    public private(set) var dictDashboards: [String : Dashboard] = [:]

    private let entityService: EntityService
    private let dashboardRepository: DashboardRepository

    public init(entityService: EntityService, dashboardRepository: DashboardRepository) {
        self.entityService = entityService
        self.dashboardRepository = dashboardRepository
        loadDashboards()
    }

    private func loadDashboards() {
        Task {
            let allDashboards = try? await self.dashboardRepository.fetchDashboards()
            for dashboard in allDashboards ?? [] {
                dashboard.entities = dashboard.entitiesIDs.compactMap { entityService.entities.all[$0] }
                dictDashboards[dashboard.name] = dashboard
            }
        }
    }
}

// MARK: - ConfigService

extension DashboardServiceImpl: DashboardService {

    public var dashboards: [Dashboard] { Array(dictDashboards.values) }

    public func persist() async throws{
        try await dashboardRepository.save(dashboard: dashboards)
    }

    public func add(dashboard: Dashboard) throws {
        guard !dictDashboards.keys.contains(dashboard.name) else {
            throw DashboardServiceError.dashboardAlreadyExists
        }
        dictDashboards[dashboard.name] = dashboard
    }

    public func delete(dashboardName: String) {
        dictDashboards[dashboardName] = nil
    }

    public func addEntity(_ entity: Entity, dashboardName: String) {
        dictDashboards[dashboardName]?.entities.append(entity)
    }

    public func addEntities(_ entities: [Entity], dashboardName: String) {
        dictDashboards[dashboardName]?.entities.append(contentsOf: entities)
    }

    public func removeEntity(_ entityID: String, dashboardName: String) {
        dictDashboards[dashboardName]?.entities.removeAll(where: { $0.id == entityID })
    }

    public func removeEntities(_ entityIDs: [String], dashboardName: String) {
        dictDashboards[dashboardName]?.entities.removeAll(where: { entityIDs.contains($0.id) })
    }
}