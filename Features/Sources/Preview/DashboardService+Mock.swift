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
    public static let bedroom = Domain.Dashboard(
        name: "Bedroom",
        icon: "bed.double",
        widgetConfigs: [
            .init(id: "1", entityID: EntityMock.ledDeskLight.id, uiType: "light"),
            .init(id: "2", entityID: EntityMock.ledCeilingLight.id, uiType: "light"),
            .init(id: "3", entityID: EntityMock.fan.id, uiType: "fan"),
        ]
    )

    public static let living = Domain.Dashboard(
        name: "Living Room",
        icon: "sofa",
        widgetConfigs: [
            .init(id: "4", entityID: EntityMock.climate.id, uiType: "climate"),
        ]
    )

    public static let kitchen = Domain.Dashboard(
        name: "Kitchen",
        icon: "refrigerator",
        widgetConfigs: [
            .init(id: "5", entityID: EntityMock.coffeeMachine.id, uiType: "switch"),
        ]
    )

    public static let garden = Domain.Dashboard(
        name: "Garden",
        icon: "tree",
        widgetConfigs: [
            .init(id: "6", entityID: EntityMock.mainLight.id, uiType: "light"),
            .init(id: "7", entityID: EntityMock.fan.id, uiType: "fan"),
        ]
    )

    public static let security = Domain.Dashboard(
        name: "Security",
        icon: "light.beacon.max",
        widgetConfigs: [
            .init(id: "8", entityID: EntityMock.mainLight.id, uiType: "light"),
        ]
    )

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
