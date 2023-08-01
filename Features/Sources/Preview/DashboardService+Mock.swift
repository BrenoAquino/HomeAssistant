//
//  DashboardService+Mock.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

//#if DEBUG || PREVIEW
import Combine
import Domain
import Foundation

public enum WidgetsMock {

    public static func createLightWidget(
        uiType: String,
        name: String,
        state: LightEntity.State
    ) -> (WidgetConfig, any Entity) {
        let entityID = UUID().uuidString
        let entity = LightEntity(id: entityID, name: name, state: state)
        let widgetConfig = WidgetConfig(id: UUID().uuidString, entityID: entityID, uiType: uiType)
        return (widgetConfig, entity)
    }

    public static func createFanWidget(
        uiType: String,
        name: String,
        state: FanEntity.State,
        percentageStep: Double? = nil,
        percentage: Double? = nil
    ) -> (WidgetConfig, any Entity) {
        let entityID = UUID().uuidString
        let entity = FanEntity(id: entityID, name: name, percentageStep: percentageStep, percentage: percentage, state: state)
        let widgetConfig = WidgetConfig(id: UUID().uuidString, entityID: entityID, uiType: uiType)
        return (widgetConfig, entity)
    }
}

public enum DashboardMock {
    
    public static let bedroom = Domain.Dashboard(
        name: "Bedroom",
        icon: "bed.double",
        widgetConfigs: [
            .init(id: "1", entityID: EntityMock.ledDeskLight.id),
            .init(id: "2", entityID: EntityMock.ledCeilingLight.id),
            .init(id: "3", entityID: EntityMock.fan.id, uiType: "slider"),
            .init(id: "4", entityID: EntityMock.fan.id, uiType: "slider"),
            .init(id: "5", entityID: EntityMock.mainLight.id),
        ]
    )

    public static let living = Domain.Dashboard(
        name: "Living Room",
        icon: "sofa",
        widgetConfigs: [
            .init(id: "4", entityID: EntityMock.climate.id),
        ]
    )

    public static let kitchen = Domain.Dashboard(
        name: "Kitchen",
        icon: "refrigerator",
        widgetConfigs: [
            .init(id: "5", entityID: EntityMock.coffeeMachine.id),
        ]
    )

    public static let garden = Domain.Dashboard(
        name: "Garden",
        icon: "tree",
        widgetConfigs: [
            .init(id: "6", entityID: EntityMock.mainLight.id),
            .init(id: "7", entityID: EntityMock.fan.id),
        ]
    )

    public static let security = Domain.Dashboard(
        name: "Security",
        icon: "light.beacon.max",
        widgetConfigs: [
            .init(id: "8", entityID: EntityMock.mainLight.id),
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
//#endif
