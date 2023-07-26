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
    public static var allDict: [String : Dashboard] = all.reduce(into: [:], { $0[$1.name] = $1 })
}

public class DashboardServiceMock: Domain.DashboardService {

    public var dashboardOrder: CurrentValueSubject<[String], Never> = .init(DashboardMock.all.map { $0.name })
    public var dashboards: CurrentValueSubject<[String : Domain.Dashboard], Never> = .init(DashboardMock.allDict)

    public init() {}

    public func load() async throws {}
    public func persist() async throws {}
    public func add(dashboard: Dashboard) throws {}
    public func update(dashboardName: String, dashboard: Dashboard) throws {}
    public func delete(dashboardName: String) {}
    public func updateAll(dashboards: [Domain.Dashboard]) {}
    public func update(order: [String]) throws {}
}

#endif
