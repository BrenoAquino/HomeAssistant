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
    ) -> WidgetData {
        let entityID = UUID().uuidString
        let entity = LightEntity(id: entityID, name: name, state: state)
        let widgetConfig = WidgetConfig(id: UUID().uuidString, entityID: entityID, title: entity.name, uiType: uiType)
        return WidgetData(config: widgetConfig, entity: entity)
    }

    public static func createFanWidget(
        uiType: String,
        name: String,
        state: FanEntity.State,
        percentageStep: Double? = nil,
        percentage: Double? = nil
    ) -> WidgetData {
        let entityID = UUID().uuidString
        let entity = FanEntity(id: entityID, name: name, percentageStep: percentageStep, percentage: percentage, state: state)
        let widgetConfig = WidgetConfig(id: UUID().uuidString, entityID: entityID, title: entity.name, uiType: uiType)
        return WidgetData(config: widgetConfig, entity: entity)
    }
}

public enum DashboardMock {
    
    public static let bedroom = Domain.Dashboard(
        name: "Bedroom",
        icon: "bed.double",
        columns: 3,
        widgetConfigs: [
            .init(id: "1", entityID: EntityMock.ledDeskLight.id, title: EntityMock.ledDeskLight.name),
            .init(id: "2", entityID: EntityMock.ledCeilingLight.id, title: EntityMock.ledCeilingLight.name),
            .init(id: "3", entityID: EntityMock.fan.id, title: EntityMock.fan.name, uiType: "slider"),
            .init(id: "4", entityID: EntityMock.fan.id, title: EntityMock.fan.name, uiType: "slider"),
            .init(id: "5", entityID: EntityMock.mainLight.id, title: EntityMock.mainLight.name),
        ]
    )

    public static let living = Domain.Dashboard(
        name: "Living Room",
        icon: "sofa",
        columns: 3,
        widgetConfigs: [
            .init(id: "4", entityID: EntityMock.climate.id, title: EntityMock.climate.name),
        ]
    )

    public static let kitchen = Domain.Dashboard(
        name: "Kitchen",
        icon: "refrigerator",
        columns: 3,
        widgetConfigs: [
            .init(id: "5", entityID: EntityMock.coffeeMachine.id, title: EntityMock.coffeeMachine.name),
        ]
    )

    public static let garden = Domain.Dashboard(
        name: "Garden",
        icon: "tree",
        columns: 3,
        widgetConfigs: [
            .init(id: "6", entityID: EntityMock.mainLight.id, title: EntityMock.mainLight.name),
            .init(id: "7", entityID: EntityMock.fan.id, title: EntityMock.fan.name),
        ]
    )

    public static let security = Domain.Dashboard(
        name: "Security",
        icon: "light.beacon.max",
        columns: 3,
        widgetConfigs: [
            .init(id: "8", entityID: EntityMock.mainLight.id, title: EntityMock.mainLight.name),
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
