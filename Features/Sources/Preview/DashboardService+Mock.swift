//
//  DashboardService+Mock.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

#if DEBUG
import Combine
import Domain
import Foundation

public enum DashboardMock {
    public static let bedroom = Domain.Dashboard(name: "Bedroom", icon: "bed.double", entities: [
        EntityMock.ledDeskLight.id, EntityMock.ledCeilingLight.id, EntityMock.fan.id
    ])
    public static let living = Domain.Dashboard(name: "Living Room", icon: "sofa", entities: [
        EntityMock.climate.id
    ])
    public static let kitchen = Domain.Dashboard(name: "Kitchen", icon: "refrigerator", entities: [
        EntityMock.coffeeMachine.id
    ])
    public static let garden = Domain.Dashboard(name: "Garden", icon: "tree", entities: [
        EntityMock.mainLight.id, EntityMock.fan.id
    ])
    public static let security = Domain.Dashboard(name: "Security", icon: "light.beacon.max", entities: [
        EntityMock.mainLight.id
    ])

    public static let all = [bedroom, living, kitchen, garden, security]
}

public class DashboardServiceMock: Domain.DashboardService {

    private var cachedDashboards: [Domain.Dashboard] = []
    public var dashboards: CurrentValueSubject<[Domain.Dashboard], Never> = .init(DashboardMock.all)

    public init() {}

    public func load() async throws {}

    public func persist() async throws {}

    public func add(dashboard: Dashboard) throws {
        cachedDashboards.append(dashboard)
        dashboards.send(cachedDashboards)
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        cachedDashboards.removeAll(where: { $0.name == dashboardName })
        cachedDashboards.append(dashboard)
        dashboards.send(cachedDashboards)
    }

    public func delete(dashboardName: String) {
        cachedDashboards.removeAll(where: { $0.name == dashboardName })
        dashboards.send(cachedDashboards)
    }

    public func updateAll(dashboards: [Domain.Dashboard]) {
        self.cachedDashboards = dashboards
        self.dashboards.send(cachedDashboards)
    }
}

#endif
