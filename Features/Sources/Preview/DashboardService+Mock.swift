//
//  DashboardService+Mock.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

#if DEBUG
import Domain
import Foundation

public class DashboardServiceMock: Domain.DashboardService {

    public var dashboards: [Dashboard]

    public init(dashboards: [Dashboard] = [
        .init(name: "Quarto", icon: "bed.double"),
        .init(name: "Sala", icon: "sofa"),
        .init(name: "Cozinha", icon: "refrigerator"),
        .init(name: "Jardim", icon: "tree"),
        .init(name: "Segurança", icon: "light.beacon.max"),
    ]) {
        self.dashboards = dashboards
    }

    public func persist() async throws {}
    public func add(dashboard: Dashboard) throws {}
    public func delete(dashboardName: String) {}
    public func addEntity(_ entity: Entity, dashboardName: String) {}
    public func addEntities(_ entities: [Entity], dashboardName: String) {}
    public func removeEntity(_ entityID: String, dashboardName: String) {}
    public func removeEntities(_ entityIDs: [String], dashboardName: String) {}
}

#endif
