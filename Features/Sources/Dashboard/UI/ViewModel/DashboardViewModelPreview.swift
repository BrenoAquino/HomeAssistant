//
//  DashboardViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Combine
import Domain
import Preview

class DashboardViewModelPreview: DashboardViewModel {

    var delegate: DashboardExternalFlow?
    var toastData: DefaultToastDataContent?
    var removeWidgetAlert: Bool = false
    var removeDashboardAlert: Bool = false
    var editModel: Bool = false
    var selectedDashboardName: String? = "Bedroom"
    var dashboards: [Dashboard] = DashboardMock.all
    var widgets: [WidgetData] = [
        .init(
            config: WidgetConfig(id: "1", entityID: EntityMock.mainLight.id, customInfo: .init(title: EntityMock.mainLight.name)),
            entity: EntityMock.mainLight
        ),
        .init(
            config: WidgetConfig(id: "2", entityID: EntityMock.ledDeskLight.id, customInfo: .init(title: EntityMock.ledDeskLight.name)),
            entity: EntityMock.ledDeskLight
        ),
        .init(
            config: WidgetConfig(id: "3", entityID: EntityMock.ledCeilingLight.id, customInfo: .init(title: EntityMock.ledCeilingLight.name)),
            entity: EntityMock.ledCeilingLight
        ),
    ]

    var currentDashboard: Dashboard? {
        return dashboards[0]
    }

    func deleteRequestedDashboard() {}
    func cancelDashboardDeletion() {}
    func deleteRequestedWidget() {}
    func cancelWidgetDeletion() {}
    func didUpdateEntitiesOrder(_ entities: [any Entity]) {}
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard]) {}
    func didClickAddDashboard() {}
    func didClickRemove(dashboard: Dashboard) {}
    func didClickEdit(dashboard: Dashboard) {}
    func didClickEdit(widget: WidgetData) {}
    func didClickRemove(entity: any Entity) {}
    func didClickConfig() {}
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {}
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State) {}
    func didUpdateWidgetsOrder(_ widgets: [WidgetData]) {}
    func didClickRemove(widget: WidgetData) {}
    func didClickAddWidget() {}
}
#endif
