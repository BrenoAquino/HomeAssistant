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
    var removeEntityAlert: Bool = false
    var removeDashboardAlert: Bool = false
    var editModel: Bool = false
    var selectedDashboardName: String? = "Bedroom"
    var dashboards: [Dashboard] = DashboardMock.all
    var widgets: [(widget: EntityWidget, entity: any Entity)] = [
        (EntityWidget(entityID: EntityMock.mainLight.id, uiType: "light"), EntityMock.mainLight),
        (EntityWidget(entityID: EntityMock.ledDeskLight.id, uiType: "light"), EntityMock.ledDeskLight),
        (EntityWidget(entityID: EntityMock.ledCeilingLight.id, uiType: "light"), EntityMock.ledCeilingLight),
    ]

    var currentDashboard: Dashboard? {
        return dashboards[0]
    }

    func deleteRequestedDashboard() {}
    func cancelDashboardDeletion() {}
    func deleteRequestedEntity() {}
    func cancelEntityDeletion() {}
    func didUpdateEntitiesOrder(_ entities: [any Entity]) {}
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard]) {}
    func didClickAddDashboard() {}
    func didClickRemove(dashboard: Dashboard) {}
    func didClickEdit(dashboard: Dashboard) {}
    func didClickRemove(entity: any Entity) {}
    func didClickConfig() {}
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {}
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State) {}
}
#endif
