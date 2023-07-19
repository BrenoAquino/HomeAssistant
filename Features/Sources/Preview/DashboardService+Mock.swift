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
    public func add(dashboard: Dashboard) throws {}
    public func delete(dashboardName: String) {}
    public func addEntity(_ entity: Entity, dashboardName: String) {}
    public func addEntities(_ entities: [Entity], dashboardName: String) {}
    public func removeEntity(_ entityID: String, dashboardName: String) {}
    public func removeEntities(_ entityIDs: [String], dashboardName: String) {}
}

#endif
