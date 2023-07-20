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

public class DashboardServiceMock: Domain.DashboardService {

    public var dashboards: CurrentValueSubject<[Dashboard], Never> = .init([
        .init(name: "Bedroom", icon: "bed.double", entities: [""]),
        .init(name: "Living Room", icon: "sofa", entities: [""]),
        .init(name: "Kitchen", icon: "refrigerator", entities: [""]),
        .init(name: "Garden", icon: "tree", entities: [""]),
        .init(name: "Security", icon: "light.beacon.max", entities: [""]),
    ])

    public init() {}

    public func trackDashboards() async throws {}

    public func persist() async throws {}

    public func add(dashboard: Dashboard) throws {
        let all = dashboards.value.appended(dashboard)
        dashboards.send(all)
    }

    public func update(dashboardName: String, dashboard: Dashboard) throws {
        let all = dashboards.value.appended(dashboard)
        dashboards.send(all)
    }

    public func delete(dashboardName: String) {
        var all = dashboards.value
        all.removeAll(where: { $0.name == dashboardName })
        dashboards.send(all)
    }

    public func updateAll(dashboards: [Domain.Dashboard]) {
        
    }
}

#endif
