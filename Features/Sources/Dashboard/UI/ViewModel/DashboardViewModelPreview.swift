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
    var externalFlows: DashboardExternalFlow?
    var toastData: DefaultToastDataContent?
    var removeWidgetAlert: Bool = false
    var removeDashboardAlert: Bool = false
    var editModel: Bool = false
    var selectedDashboardName: String? = "Bedroom"
    var dashboards: [Dashboard] = Dashboard.all
    var currentDashboard: Dashboard? {
        return dashboards[0]
    }
    var widgets: [WidgetData] = [
        .init(
            config: .mock(entity: LightEntity.mockMainLight),
            entity: LightEntity.mockMainLight
        ),
        .init(
            config: .mock(entity: LightEntity.mockLedDeskLight),
            entity: LightEntity.mockLedDeskLight
        ),
        .init(
            config: .mock(entity: LightEntity.mockLedCeilingLight),
            entity: LightEntity.mockLedCeilingLight
        ),
    ]
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
