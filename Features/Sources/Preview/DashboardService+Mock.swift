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
        .init(name: "Bedroom", icon: "bed.double"),
        .init(name: "Living Room", icon: "sofa"),
        .init(name: "Kitchen", icon: "refrigerator"),
        .init(name: "Garden", icon: "tree"),
        .init(name: "Security", icon: "light.beacon.max"),
    ])

    public init() {}

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
}

#endif
